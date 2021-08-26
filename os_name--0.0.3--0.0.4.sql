-- complain if script is sourced in psql, rather than via ALTER EXTENSION
\echo Use "ALTER EXTENSION os_name UPDATE TO '0.0.4'" to load this file. \quit

CREATE FUNCTION os_name_get_list()
RETURNS text[]
AS '$libdir/os_name'
LANGUAGE C IMMUTABLE PARALLEL SAFE;
