\t
CREATE EXTENSION os_name;

CREATE TABLE os_name_table (v os_name);

COPY (SELECT unnest(n::os_name[])
	FROM os_name_get_list() s(n))
	TO '/tmp/tst' WITH (FORMAT binary);
COPY os_name_table
	FROM '/tmp/tst' WITH (FORMAT binary);

SELECT * FROM os_name_table;
