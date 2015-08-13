#include "os_name.h"
PG_MODULE_MAGIC;

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
      case BADA: return create_string(CONST_STRING("bada"));
      case BLACKBERRY: return create_string(CONST_STRING("blackberry"));
      case IOS: return create_string(CONST_STRING("ios"));
      case LINUX: return create_string(CONST_STRING("linux"));
      case MACOS: return create_string(CONST_STRING("macos"));
      case SERVER: return create_string(CONST_STRING("server"));
      case SYMBIAN: return create_string(CONST_STRING("symbian"));
      case WEBOS: return create_string(CONST_STRING("webos"));
      case WINDOWS: return create_string(CONST_STRING("windows"));
      case WPHONE: return create_string(CONST_STRING("windows-phone"));
      case UNKNOWN: return create_string(CONST_STRING("unknown"));
      default: elog(ERROR, "internal error unexpected num in os_name_to_str");
  }
}

static inline uint8
check_os_name_num(const char *str, const char *expected, os_name os)
{
    if (strcmp(expected, str) != 0)
        return 0;

    return os;
}

static inline uint8
get_os_name_num_b(const char *str)
{
    switch (str[1]) {
        case 'a': return check_os_name_num(str, "bada", BADA);
        case 'l': return check_os_name_num(str, "blackberry", BLACKBERRY);
        default : return 0;
    }
}

static inline uint8
get_os_name_num_s(const char *str)
{
    switch (str[1]) {
        case 'e': return check_os_name_num(str, "server", SERVER);
        case 'y': return check_os_name_num(str, "symbian", SYMBIAN);
        default : return 0;
    }
}

static inline uint8
get_os_name_num_w(const char *str)
{
    switch (str[1]) {
        case 'e': return check_os_name_num(str, "webos", WEBOS);
        case 'i':
            if(str[7] == '-'  )
                return check_os_name_num(str, "windows-phone", WPHONE);
            else
                return check_os_name_num(str, "windows", WINDOWS);
        default : return 0;
    }
}

 /*
	allowed are
 		android
    blackberry
    ios
    linux
    macos
    server
    symbian
    webos
    windows
    windows
    unknown
*/
static inline
os_name os_name_from_str(const char *str)
{
	if (strlen(str) < 3)
		elog(ERROR, "unknown input os_name: %s", str);

	switch (str[0])
	{
		case 'a': return check_os_name_num(str, "android", ANDROID);
    case 'b': return get_os_name_num_b(str);
    case 'i': return check_os_name_num(str, "ios", IOS);
    case 'l': return check_os_name_num(str, "linux", LINUX);
    case 'm': return check_os_name_num(str, "macos", MACOS);
    case 's': return get_os_name_num_s(str);
    case 'w': return get_os_name_num_w(str);
    case 'u': return check_os_name_num(str, "unknown", UNKNOWN);
	}

  elog(ERROR, "unknown input os_name: %s", str);

	return 0; //keep compiler quit//
}


PG_FUNCTION_INFO_V1(os_name_in);
Datum
os_name_in(PG_FUNCTION_ARGS)
{
	char *str = PG_GETARG_CSTRING(0);
	for(int i = 0; str[i]; i++){
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
	os_name c = PG_GETARG_UINT8(0);
	StringInfoData buf;

	pq_begintypsend(&buf);
	pq_sendbyte(&buf, c);

	PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}

PG_FUNCTION_INFO_V1(os_name_eq);
Datum
os_name_eq(PG_FUNCTION_ARGS)
{
  os_name    arg1 = PG_GETARG_UINT8(0);
  os_name    arg2 = PG_GETARG_UINT8(1);

  PG_RETURN_BOOL(arg1 == arg2);
}

PG_FUNCTION_INFO_V1(os_name_ne);
Datum
os_name_ne(PG_FUNCTION_ARGS)
{
  os_name    arg1 = PG_GETARG_UINT8(0);
  os_name    arg2 = PG_GETARG_UINT8(1);

  PG_RETURN_BOOL(arg1 != arg2);
}

PG_FUNCTION_INFO_V1(os_name_lt);
Datum
os_name_lt(PG_FUNCTION_ARGS)
{
  os_name    arg1 = PG_GETARG_UINT8(0);
  os_name    arg2 = PG_GETARG_UINT8(1);

  PG_RETURN_BOOL(arg1 < arg2);
}

PG_FUNCTION_INFO_V1(os_name_le);
Datum
os_name_le(PG_FUNCTION_ARGS)
{
  os_name    arg1 = PG_GETARG_UINT8(0);
  os_name    arg2 = PG_GETARG_UINT8(1);

  PG_RETURN_BOOL(arg1 <= arg2);
}

PG_FUNCTION_INFO_V1(os_name_gt);
Datum
os_name_gt(PG_FUNCTION_ARGS)
{
  os_name    arg1 = PG_GETARG_UINT8(0);
  os_name    arg2 = PG_GETARG_UINT8(1);

  PG_RETURN_BOOL(arg1 > arg2);
}

PG_FUNCTION_INFO_V1(os_name_ge);
Datum
os_name_ge(PG_FUNCTION_ARGS)
{
  os_name    arg1 = PG_GETARG_UINT8(0);
  os_name    arg2 = PG_GETARG_UINT8(1);

  PG_RETURN_BOOL(arg1 >= arg2);
}

PG_FUNCTION_INFO_V1(os_name_cmp);
Datum
os_name_cmp(PG_FUNCTION_ARGS)
{
  os_name a = PG_GETARG_UINT8(0);
  os_name b = PG_GETARG_UINT8(1);

  PG_RETURN_INT32((int32) a - (int32) b);
}

PG_FUNCTION_INFO_V1(hash_os_name);
Datum
hash_os_name(PG_FUNCTION_ARGS)
{
  return hash_uint32((int32) PG_GETARG_UINT8(0));
}
