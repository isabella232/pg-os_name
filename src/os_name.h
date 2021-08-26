#ifndef OS_NAME_H
#define OS_NAME_H

#include "postgres.h"
#include "fmgr.h"
#include "libpq/pqformat.h"
#include "access/hash.h"

typedef uint8 os_name;

#define CONST_STRING(s) (sizeof(s)/sizeof(s[0])), s
#define PG_RETURN_UINT8(x) return UInt8GetDatum(x)
#define PG_GETARG_UINT8(x) DatumGetUInt8(PG_GETARG_DATUM(x))


#define ANDROID     20
#define ANDROID_TV  30
#define BADA        40
#define BLACKBERRY  60
#define FIRE_TV     70
#define IOS         80
#define LINUX      100
#define MACOS      120
#define ROKU_TV    130
#define SAMSUNG_TV 135
#define SERVER     140
#define SYMBIAN    160
#define WEBOS      180
#define WINDOWS    200
#define WPHONE     220
#define UNKNOWN    255


Datum os_name_in(PG_FUNCTION_ARGS);
Datum os_name_out(PG_FUNCTION_ARGS);
Datum os_name_recv(PG_FUNCTION_ARGS);
Datum os_name_send(PG_FUNCTION_ARGS);
Datum os_name_eq(PG_FUNCTION_ARGS);
Datum os_name_ne(PG_FUNCTION_ARGS);
Datum os_name_lt(PG_FUNCTION_ARGS);
Datum os_name_le(PG_FUNCTION_ARGS);
Datum os_name_gt(PG_FUNCTION_ARGS);
Datum os_name_ge(PG_FUNCTION_ARGS);
Datum os_name_cmp(PG_FUNCTION_ARGS);
Datum hash_os_name(PG_FUNCTION_ARGS);
#endif // OS_NAME_H
