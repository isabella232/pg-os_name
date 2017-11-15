

DO $$
DECLARE version_num integer;
BEGIN
  SELECT current_setting('server_version_num') INTO STRICT version_num;
  IF version_num > 90600 THEN
	EXECUTE $E$ ALTER FUNCTION os_name_in(cstring) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_out(os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_recv(internal) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_send(os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_eq(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_ne(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_lt(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_le(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_gt(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_ge(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION os_name_cmp(os_name, os_name) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION hash_os_name(os_name) PARALLEL SAFE $E$;
  END IF;
END;
$$;

