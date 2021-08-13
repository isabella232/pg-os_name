\t
SET max_parallel_workers_per_gather=4;
SET force_parallel_mode=on;
set parallel_setup_cost = 10;
set parallel_tuple_cost = 0.001;

CREATE TABLE os_name_parallel(v os_name) WITH (parallel_workers = 4);
INSERT INTO os_name_parallel(v)
	SELECT values.v
	FROM generate_series(1,1e4) i,
	LATERAL (SELECT v FROM os_name_table ORDER BY random() LIMIT 1) values;

EXPLAIN (costs off, verbose)
SELECT COUNT(*) FROM os_name_parallel WHERE v = 'android';

EXPLAIN (costs off, verbose)
SELECT v, COUNT(*) FROM os_name_parallel GROUP BY 1;