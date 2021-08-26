\t
SELECT v::text::os_name
FROM os_name_table;

SELECT 'invalid_name'::os_name;
SELECT ''::os_name;