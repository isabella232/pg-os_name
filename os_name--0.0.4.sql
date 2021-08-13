
-- os_name definition

CREATE FUNCTION os_name_in(cstring)
RETURNS os_name
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_out(os_name)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_recv(internal)
RETURNS os_name
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_send(os_name)
RETURNS bytea
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE os_name (
	INPUT     = os_name_in,
	OUTPUT    = os_name_out,
	RECEIVE   = os_name_recv,
	SEND      = os_name_send,
	LIKE      = "char",
	CATEGORY  = 'S'
);
COMMENT ON TYPE os_name IS 'an os_name internaly stored as uint8';

-- Operators for os_name

CREATE FUNCTION os_name_eq(os_name, os_name)
RETURNS boolean
AS 'chareq'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_ne(os_name, os_name)
RETURNS boolean
AS 'charne'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_lt(os_name, os_name)
RETURNS boolean
AS 'charlt'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_le(os_name, os_name)
RETURNS boolean
AS 'charle'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_gt(os_name, os_name)
RETURNS boolean
AS 'chargt'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_ge(os_name, os_name)
RETURNS boolean
AS 'charge'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION os_name_cmp(os_name, os_name)
RETURNS integer
AS 'btcharcmp'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION hash_os_name(os_name)
RETURNS integer
AS 'hashchar'
LANGUAGE internal IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR = (
	LEFTARG = os_name,
	RIGHTARG = os_name,
	PROCEDURE = os_name_eq,
	COMMUTATOR = '=',
	NEGATOR = '<>',
	RESTRICT = eqsel,
	JOIN = eqjoinsel,
	HASHES, MERGES
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

-- Postgres 11 has more optimal RESTRICT and JOIN selectivity estimation functions
DO $$
DECLARE version_num integer;
BEGIN
	SELECT current_setting('server_version_num') INTO STRICT version_num;
	IF version_num < 110000 THEN

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

	ELSE

		CREATE OPERATOR <= (
			LEFTARG = os_name,
			RIGHTARG = os_name,
			PROCEDURE = os_name_le,
			COMMUTATOR = >= ,
			NEGATOR = > ,
			RESTRICT = scalarlesel,
			JOIN = scalarlejoinsel
		);
		COMMENT ON OPERATOR <=(os_name, os_name) IS 'less-than-or-equal';

		CREATE OPERATOR >= (
			LEFTARG = os_name,
			RIGHTARG = os_name,
			PROCEDURE = os_name_ge,
			COMMUTATOR = <= ,
			NEGATOR = < ,
			RESTRICT = scalargesel,
			JOIN = scalargejoinsel
		);
		COMMENT ON OPERATOR >=(os_name, os_name) IS 'greater-than-or-equal';

	END IF;
END;
$$;

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
DEFAULT FOR TYPE os_name USING hash
AS
	OPERATOR        1       = ,
	FUNCTION        1       hash_os_name(os_name);

-- os_name SQL-callable functions

CREATE FUNCTION os_name_get_list()
RETURNS text[]
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE PARALLEL SAFE;

