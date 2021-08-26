CREATE FUNCTION os_name_in(cstring)
RETURNS os_name
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION os_name_out(os_name)
RETURNS cstring
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION os_name_recv(internal)
RETURNS os_name
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION os_name_send(os_name)
RETURNS bytea
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE os_name (
	INPUT          = os_name_in,
	OUTPUT         = os_name_out,
	RECEIVE        = os_name_recv,
	SEND           = os_name_send,
	LIKE           = "char",
	CATEGORY       = 'S'
);
COMMENT ON TYPE os_name IS 'a os_name internaly stored as char';

CREATE FUNCTION os_name_eq(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION os_name_ne(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION os_name_lt(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION os_name_le(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION os_name_gt(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION os_name_ge(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION os_name_cmp(os_name, os_name)
RETURNS integer LANGUAGE C IMMUTABLE AS '$libdir/os_name';

CREATE FUNCTION hash_os_name(os_name)
RETURNS integer LANGUAGE C IMMUTABLE AS '$libdir/os_name';


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

CREATE OPERATOR = (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_eq,
	COMMUTATOR = '=',
	NEGATOR = '<>',
	RESTRICT = eqsel,
	JOIN = eqjoinsel
);
COMMENT ON OPERATOR =(os_name, os_name) IS 'equals?';

CREATE OPERATOR <> (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_ne,
	COMMUTATOR = '<>',
	NEGATOR = '=',
	RESTRICT = neqsel,
	JOIN = neqjoinsel
);
COMMENT ON OPERATOR <>(os_name, os_name) IS 'not equals?';

CREATE OPERATOR < (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_lt,
	COMMUTATOR = > ,
	NEGATOR = >= ,
   	RESTRICT = scalarltsel,
	JOIN = scalarltjoinsel
);
COMMENT ON OPERATOR <(os_name, os_name) IS 'less-than';

CREATE OPERATOR <= (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_le,
	COMMUTATOR = >= ,
	NEGATOR = > ,
   	RESTRICT = scalarltsel,
	JOIN = scalarltjoinsel
);
COMMENT ON OPERATOR <=(os_name, os_name) IS 'less-than-or-equal';

CREATE OPERATOR > (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_gt,
	COMMUTATOR = < ,
	NEGATOR = <= ,
   	RESTRICT = scalargtsel,
	JOIN = scalargtjoinsel
);
COMMENT ON OPERATOR >(os_name, os_name) IS 'greater-than';

CREATE OPERATOR >= (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_ge,
	COMMUTATOR = <= ,
	NEGATOR = < ,
   	RESTRICT = scalargtsel,
	JOIN = scalargtjoinsel
);
COMMENT ON OPERATOR >=(os_name, os_name) IS 'greater-than-or-equal';

CREATE OPERATOR CLASS btree_os_name_ops
DEFAULT FOR TYPE os_name USING btree
AS
        OPERATOR        1       <  ,
        OPERATOR        2       <= ,
        OPERATOR        3       =  ,
        OPERATOR        4       >= ,
        OPERATOR        5       >  ,
        FUNCTION        1       os_name_cmp(os_name, os_name);

CREATE OPERATOR CLASS hash_os_name_ops
    DEFAULT FOR TYPE os_name USING hash AS
        OPERATOR        1       = ,
        FUNCTION        1       hash_os_name(os_name);

CREATE FUNCTION os_name_get_list()
RETURNS text[]
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE PARALLEL SAFE;
