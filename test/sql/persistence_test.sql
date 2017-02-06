BEGIN;
-- persistence should persist os_names;
-- ./spec/persistence_spec.rb:8;
CREATE EXTENSION os_name;
CREATE TABLE os_name_test AS SELECT 'ios'::os_name, 1 as num;
SELECT * FROM os_name_test;
UPDATE os_name_test SET num = 2;
SELECT * FROM os_name_test;
ROLLBACK;
