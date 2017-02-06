-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION os_name" to load this file. \quit
--source file sql/os_name.sql
CREATE FUNCTION os_name_in(cstring)
RETURNS os_name
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_out(os_name)
RETURNS cstring
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_recv(internal)
RETURNS os_name
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_send(os_name)
RETURNS bytea
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

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
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION os_name_ne(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION os_name_lt(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION os_name_le(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION os_name_gt(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION os_name_ge(os_name, os_name)
RETURNS boolean LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION os_name_cmp(os_name, os_name)
RETURNS integer LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

CREATE FUNCTION hash_os_name(os_name)
RETURNS integer LANGUAGE C IMMUTABLE AS '$libdir/os_name' PARALLEL SAFE;

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
 
