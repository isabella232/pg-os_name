BEGIN;
create extension os_name;
SET max_parallel_workers_per_gather=4;
SET force_parallel_mode=on;

CREATE TABLE parallel_test(i int, c os_name) WITH (parallel_workers = 4);
INSERT INTO parallel_test (i, c)
SELECT i, c.country
FROM generate_series(1,1e6) i,
LATERAL (SELECT CASE WHEN i % 3 = 0 THEN 'android'
                     WHEN i % 3 = 1 THEN 'linux'
                     WHEN i % 3 = 2 THEN 'windows'
         END as country) c;

EXPLAIN (costs off,verbose)
SELECT COUNT(*) FROM parallel_test WHERE  c = 'linux';

EXPLAIN (costs off,verbose)
SELECT c, COUNT(*) FROM parallel_test GROUP BY 1;
ROLLBACK;
