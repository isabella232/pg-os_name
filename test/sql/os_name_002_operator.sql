\t
CREATE TABLE os_name_table_window
AS SELECT
		name cur_value,
		(LEAD(name) OVER ()) next_value
	FROM (SELECT unnest(name::os_name[]) AS name
		FROM os_name_get_list() list(name)) list;

SELECT
	cur_value > next_value AS gt,
	cur_value >= next_value AS ge,
	cur_value >= cur_value AS ge2,
	cur_value < next_value AS lt,
	cur_value <= next_value AS le,
	cur_value <= cur_value AS le2,
	cur_value = cur_value AS eq,
	cur_value != cur_value AS nq
FROM os_name_table_window;