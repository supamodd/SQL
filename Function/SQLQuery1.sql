USE SPU_411_Import;
GO

-- Проверяем, существует ли функция вообще
SELECT OBJECT_SCHEMA_NAME(object_id) AS schema_name,
       name,
       type_desc,
       create_date
FROM sys.objects
WHERE name = 'GetLastDate';