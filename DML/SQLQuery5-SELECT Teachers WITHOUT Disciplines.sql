--SQLQuery5-SELECT Teachers WITHOUT Disciplines
USE SPU_411_Import;

SELECT 
    last_name + ' ' + first_name + ' ' + ISNULL(middle_name, '') AS [Преподаватель],
    COUNT(discipline) AS [Количество дисциплин]

FROM Teachers
LEFT JOIN TeachersDisciplinesRelation td 
    ON teacher_id = teacher_id

GROUP BY 
    teacher_id,
    last_name,
    first_name,
    middle_name

HAVING COUNT(discipline) = 0

ORDER BY 
    last_name, 
    first_name, 
    middle_name;