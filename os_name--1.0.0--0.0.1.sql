----functions----
CREATE OR REPLACE FUNCTION os_name_cmp(os_name, os_name)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_cmp$function$;
----
CREATE OR REPLACE FUNCTION os_name_ge(os_name, os_name)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_ge$function$;
----
CREATE OR REPLACE FUNCTION os_name_gt(os_name, os_name)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_gt$function$;
----
CREATE OR REPLACE FUNCTION os_name_le(os_name, os_name)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_le$function$;
----
CREATE OR REPLACE FUNCTION os_name_lt(os_name, os_name)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_lt$function$;
----
CREATE OR REPLACE FUNCTION os_name_ne(os_name, os_name)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_ne$function$;
----
CREATE OR REPLACE FUNCTION os_name_eq(os_name, os_name)
 RETURNS boolean
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$os_name_eq$function$;
----
CREATE OR REPLACE FUNCTION os_name_send(os_name)
 RETURNS bytea
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/os_name', $function$os_name_send$function$;
----
CREATE OR REPLACE FUNCTION os_name_recv(internal)
 RETURNS os_name
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/os_name', $function$os_name_recv$function$;
----
CREATE OR REPLACE FUNCTION os_name_out(os_name)
 RETURNS cstring
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/os_name', $function$os_name_out$function$;
----
CREATE OR REPLACE FUNCTION os_name_in(cstring)
 RETURNS os_name
 LANGUAGE c
 IMMUTABLE STRICT
AS '$libdir/os_name', $function$os_name_in$function$;
----
CREATE OR REPLACE FUNCTION hash_os_name(os_name)
 RETURNS integer
 LANGUAGE c
 IMMUTABLE
AS '$libdir/os_name', $function$hash_os_name$function$;
