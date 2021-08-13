#include "postgres.h"
#include "fmgr.h"

#include "access/hash.h"
#include "catalog/pg_type.h"
#include "lib/stringinfo.h"
#include "libpq/pqformat.h"
#include "utils/array.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

typedef uint8 pg_type;

/*
 * Type values as uint8, this definition should correspond to PG_TYPE_NAMES
 * array entries.
 */
#define PG_ANDROID 20
#define PG_ANDROID_TV 30
#define PG_BADA 40
#define PG_BLACKBERRY 60
#define PG_FIRE_TV 70
#define PG_IOS 80
#define PG_LINUX 100
#define PG_MACOS 120
#define PG_ROKU_TV 130
#define PG_SAMSUNG_TV 135
#define PG_SERVER 140
#define PG_SYMBIAN 160
#define PG_UNKNOWN 255
#define PG_WEBOS 180
#define PG_WINDOWS 200
#define PG_WINDOWS_PHONE 220

/*
 * Type values as string, this definition should correspond to their
 * indexes above.
 */
#define PG_TYPE_NAMES { \
	{ PG_ANDROID, "android" },  \
	{ PG_ANDROID_TV, "android-tv" },  \
	{ PG_BADA, "bada" },  \
	{ PG_BLACKBERRY, "blackberry" },  \
	{ PG_FIRE_TV, "fire-tv" },  \
	{ PG_IOS, "ios" },  \
	{ PG_LINUX, "linux" },  \
	{ PG_MACOS, "macos" },  \
	{ PG_ROKU_TV, "roku-tv" },  \
	{ PG_SAMSUNG_TV, "samsung-tv" },  \
	{ PG_SERVER, "server" },  \
	{ PG_SYMBIAN, "symbian" },  \
	{ PG_UNKNOWN, "unknown" },  \
	{ PG_WEBOS, "webos" },  \
	{ PG_WINDOWS, "windows" },  \
	{ PG_WINDOWS_PHONE, "windows-phone" } \
	}

typedef struct PgTypeStruct
{
	pg_type num;
	const char *name;
} PgTypeStruct;

/*
 * Sorted array of values which is used to get uint8 representation using
 * bsearch.
 */
static const PgTypeStruct pg_type_list_sorted[] = PG_TYPE_NAMES;

#define PG_TYPE_NUM	sizeof(pg_type_list_sorted) / sizeof(PgTypeStruct)

/*
 * Array of values which is used to get type name by its number.
 */
static PgTypeStruct pg_type_list[PG_UINT8_MAX + 1];
static bool pg_type_list_initialized = false;

#define PG_RETURN_UINT8(x) return UInt8GetDatum(x)
#define PG_GETARG_UINT8(x) DatumGetUInt8(PG_GETARG_DATUM(x))

PG_FUNCTION_INFO_V1(os_name_in);
PG_FUNCTION_INFO_V1(os_name_out);
PG_FUNCTION_INFO_V1(os_name_recv);
PG_FUNCTION_INFO_V1(os_name_send);

PG_FUNCTION_INFO_V1(os_name_get_list);

static int
pg_type_item_cmp(const void *p1, const void *p2)
{
	const PgTypeStruct *a1 = (const PgTypeStruct *) p1;
	const PgTypeStruct *a2 = (const PgTypeStruct *) p2;

	/* Case-independent comparison */
	return pg_strcasecmp(a1->name, a2->name);
}

static inline pg_type
pg_type_from_str(const char *str)
{
	PgTypeStruct *found;
	PgTypeStruct key;

	key.name = str;
	found = (PgTypeStruct *) bsearch(&key, pg_type_list_sorted,
									 PG_TYPE_NUM,
									 sizeof(PgTypeStruct),
									 pg_type_item_cmp);
	if (found == NULL)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("unknown input value: %s", str)));

	return found->num;
}

/*
 * Initialize large array of values by available sorted list of type values.
 */
static void
pg_type_list_initialize(void)
{
	MemSet(pg_type_list, 0, sizeof(pg_type_list));

	for (int i = 0; i < PG_TYPE_NUM; i++)
	{
		const PgTypeStruct *item = &pg_type_list_sorted[i];

		pg_type_list[item->num] = *item;
	}
}

static inline char *
pg_type_to_str(pg_type c)
{
	PgTypeStruct *res;

	if (!pg_type_list_initialized)
	{
		pg_type_list_initialize();
		pg_type_list_initialized = true;
	}

	if (c >= PG_UINT8_MAX + 1)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("unexpected type value: %d", c)));

	res = &pg_type_list[c];
	if (res->name == NULL)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("unexpected type value: %d", c)));

	return pstrdup(res->name);
}

/*
 * SQL-callable functions.
 */

Datum
os_name_in(PG_FUNCTION_ARGS)
{
	char	   *str = PG_GETARG_CSTRING(0);

	PG_RETURN_UINT8(pg_type_from_str(str));
}

Datum
os_name_out(PG_FUNCTION_ARGS)
{
	pg_type		s = PG_GETARG_UINT8(0);

	PG_RETURN_CSTRING(pg_type_to_str(s));
}

Datum
os_name_recv(PG_FUNCTION_ARGS)
{
	StringInfo	buf = (StringInfo) PG_GETARG_POINTER(0);

	PG_RETURN_UINT8(pq_getmsgbyte(buf));
}

Datum
os_name_send(PG_FUNCTION_ARGS)
{
	pg_type		s = PG_GETARG_UINT8(0);
	StringInfoData buf;

	pq_begintypsend(&buf);
	pq_sendbyte(&buf, s);

	PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}

Datum
os_name_get_list(PG_FUNCTION_ARGS)
{
	ArrayBuildState *astate = NULL;

	if (!pg_type_list_initialized)
	{
		pg_type_list_initialize();
		pg_type_list_initialized = true;
	}

	for (int i = 0; i < PG_UINT8_MAX + 1; i++)
	{
		if (pg_type_list[i].name == NULL)
			continue;

		astate = accumArrayResult(astate,
								  CStringGetTextDatum(pg_type_list[i].name),
								  false, TEXTOID, CurrentMemoryContext);
	}

	Assert(astate != NULL);
	PG_RETURN_ARRAYTYPE_P(makeArrayResult(astate, CurrentMemoryContext));
}
