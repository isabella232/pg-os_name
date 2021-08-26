#include "os_name.h"

#include "catalog/pg_type.h"
#include "utils/array.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

static const os_name INVALID_OSNAME = 0;


static inline
char * create_string (size_t size, const char *instr)
{
	char *str = palloc0(size);
	memcpy(str, instr, size);
	return str;
}

static inline
char *os_name_to_str(os_name c)
{
	switch (c)
	{
		case ANDROID: return create_string(CONST_STRING("android"));
		case ANDROID_TV: return create_string(CONST_STRING("android-tv"));
		case BADA: return create_string(CONST_STRING("bada"));
		case BLACKBERRY: return create_string(CONST_STRING("blackberry"));
		case FIRE_TV: return create_string(CONST_STRING("fire-tv"));
		case IOS: return create_string(CONST_STRING("ios"));
		case LINUX: return create_string(CONST_STRING("linux"));
		case MACOS: return create_string(CONST_STRING("macos"));
		case ROKU_TV: return create_string(CONST_STRING("roku-tv"));
		case SAMSUNG_TV: return create_string(CONST_STRING("samsung-tv"));
		case SERVER: return create_string(CONST_STRING("server"));
		case SYMBIAN: return create_string(CONST_STRING("symbian"));
		case WEBOS: return create_string(CONST_STRING("webos"));
		case WINDOWS: return create_string(CONST_STRING("windows"));
		case WPHONE: return create_string(CONST_STRING("windows-phone"));
		case UNKNOWN: return create_string(CONST_STRING("unknown"));
		default: elog(ERROR, "internal error unexpected num in os_name_to_str");
	}
}

static inline os_name
check_os_name_num(const char *str, const char *expected, os_name os)
{
	if (strcmp(expected, str) != 0)
		return INVALID_OSNAME;

	return os;
}

static inline os_name
get_os_name_num_a(const char *str)
{
	os_name		res;

	res = check_os_name_num(str, "android", ANDROID);
	if (res == INVALID_OSNAME)
		res = check_os_name_num(str, "android-tv", ANDROID_TV);

	return res;
}

static inline os_name
get_os_name_num_b(const char *str)
{
	switch (str[1]) {
		case 'a': return check_os_name_num(str, "bada", BADA);
		case 'l': return check_os_name_num(str, "blackberry", BLACKBERRY);
		default : return INVALID_OSNAME;
	}
}

static inline os_name
get_os_name_num_s(const char *str)
{
	switch (str[1]) {
		case 'a': return check_os_name_num(str, "samsung-tv", SAMSUNG_TV);
		case 'e': return check_os_name_num(str, "server", SERVER);
		case 'y': return check_os_name_num(str, "symbian", SYMBIAN);
		default : return INVALID_OSNAME;
	}
}

static inline os_name
get_os_name_num_w(const char *str)
{
	switch (str[1]) {
		case 'e': return check_os_name_num(str, "webos", WEBOS);
		case 'i':
			if(str[7] == '-'  )
				return check_os_name_num(str, "windows-phone", WPHONE);
			else
				return check_os_name_num(str, "windows", WINDOWS);
		default : return INVALID_OSNAME;
	}
}

static inline
os_name os_name_from_str(const char *str)
{
	os_name result = INVALID_OSNAME;

	if (strlen(str) < 3)
		elog(ERROR, "unknown input os_name: %s", str);

	switch (str[0])
	{
		case 'a': result = get_os_name_num_a(str); break;
		case 'b': result = get_os_name_num_b(str); break;
		case 'f': result = check_os_name_num(str, "fire-tv", FIRE_TV); break;
		case 'i': result = check_os_name_num(str, "ios", IOS); break;
		case 'l': result = check_os_name_num(str, "linux", LINUX); break;
		case 'm': result = check_os_name_num(str, "macos", MACOS); break;
		case 'r': result = check_os_name_num(str, "roku-tv", ROKU_TV); break;
		case 's': result = get_os_name_num_s(str); break;
		case 'w': result = get_os_name_num_w(str); break;
		case 'u': result = check_os_name_num(str, "unknown", UNKNOWN); break;
	}

		if(result == INVALID_OSNAME)
			elog(ERROR, "unknown input os_name: %s", str);

	return result;
}


PG_FUNCTION_INFO_V1(os_name_in);
Datum
os_name_in(PG_FUNCTION_ARGS)
{
	int			i;
	char	   *str = PG_GETARG_CSTRING(0);

	for(i = 0; str[i]; i++){
		str[i] = tolower(str[i]);
	}

	PG_RETURN_UINT8(os_name_from_str(str));
}

PG_FUNCTION_INFO_V1(os_name_out);
Datum
os_name_out(PG_FUNCTION_ARGS)
{
	os_name c = PG_GETARG_UINT8(0);
	PG_RETURN_CSTRING(os_name_to_str(c));
}

PG_FUNCTION_INFO_V1(os_name_recv);
Datum
os_name_recv(PG_FUNCTION_ARGS)
{
	StringInfo	buf = (StringInfo) PG_GETARG_POINTER(0);

	PG_RETURN_UINT8(pq_getmsgbyte(buf));
}

PG_FUNCTION_INFO_V1(os_name_send);
Datum
os_name_send(PG_FUNCTION_ARGS)
{
	os_name		c = PG_GETARG_UINT8(0);
	StringInfoData buf;

	pq_begintypsend(&buf);
	pq_sendbyte(&buf, c);

	PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}

PG_FUNCTION_INFO_V1(os_name_eq);
Datum
os_name_eq(PG_FUNCTION_ARGS)
{
	os_name		arg1 = PG_GETARG_UINT8(0);
	os_name		arg2 = PG_GETARG_UINT8(1);

	PG_RETURN_BOOL(arg1 == arg2);
}

PG_FUNCTION_INFO_V1(os_name_ne);
Datum
os_name_ne(PG_FUNCTION_ARGS)
{
	os_name		arg1 = PG_GETARG_UINT8(0);
	os_name		arg2 = PG_GETARG_UINT8(1);

	PG_RETURN_BOOL(arg1 != arg2);
}

PG_FUNCTION_INFO_V1(os_name_lt);
Datum
os_name_lt(PG_FUNCTION_ARGS)
{
	os_name		arg1 = PG_GETARG_UINT8(0);
	os_name		arg2 = PG_GETARG_UINT8(1);

	PG_RETURN_BOOL(arg1 < arg2);
}

PG_FUNCTION_INFO_V1(os_name_le);
Datum
os_name_le(PG_FUNCTION_ARGS)
{
	os_name		arg1 = PG_GETARG_UINT8(0);
	os_name		arg2 = PG_GETARG_UINT8(1);

	PG_RETURN_BOOL(arg1 <= arg2);
}

PG_FUNCTION_INFO_V1(os_name_gt);
Datum
os_name_gt(PG_FUNCTION_ARGS)
{
	os_name		arg1 = PG_GETARG_UINT8(0);
	os_name		arg2 = PG_GETARG_UINT8(1);

	PG_RETURN_BOOL(arg1 > arg2);
}

PG_FUNCTION_INFO_V1(os_name_ge);
Datum
os_name_ge(PG_FUNCTION_ARGS)
{
	os_name		arg1 = PG_GETARG_UINT8(0);
	os_name		arg2 = PG_GETARG_UINT8(1);

	PG_RETURN_BOOL(arg1 >= arg2);
}

PG_FUNCTION_INFO_V1(os_name_cmp);
Datum
os_name_cmp(PG_FUNCTION_ARGS)
{
	os_name		a = PG_GETARG_UINT8(0);
	os_name		b = PG_GETARG_UINT8(1);

	PG_RETURN_INT32((int32) a - (int32) b);
}

PG_FUNCTION_INFO_V1(hash_os_name);
Datum
hash_os_name(PG_FUNCTION_ARGS)
{
	return hash_uint32((int32) PG_GETARG_UINT8(0));
}

PG_FUNCTION_INFO_V1(os_name_get_list);
Datum
os_name_get_list(PG_FUNCTION_ARGS)
{
	ArrayBuildState *astate = NULL;

	astate = accumArrayResult(astate, CStringGetTextDatum("android"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("android-tv"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("bada"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("blackberry"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("fire-tv"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("ios"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("linux"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("macos"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("roku-tv"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("samsung-tv"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("server"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("symbian"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("webos"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("windows"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("windows-phone"),
							  false, TEXTOID, CurrentMemoryContext);
	astate = accumArrayResult(astate, CStringGetTextDatum("unknown"),
							  false, TEXTOID, CurrentMemoryContext);

	Assert(astate != NULL);
	PG_RETURN_ARRAYTYPE_P(makeArrayResult(astate, CurrentMemoryContext));
}
