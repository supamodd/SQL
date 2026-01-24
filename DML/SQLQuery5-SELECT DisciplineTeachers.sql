--SQLQuery5-SELECT DisciplineTeachers
USE SPU_411_Import;

SELECT
    last_name,
    first_name,
    middle_name,
    last_name + ' ' + first_name + ' ' + middle_name AS [Преподаватель],
    COUNT(discipline) AS [Кол-во дисциплин]

FROM Teachers
LEFT JOIN TeachersDisciplinesRelation td
    ON teacher_id = teacher_id

GROUP BY
    teacher_id,
    last_name,
    first_name,
    middle_name

ORDER BY
    [Кол-во дисциплин] DESC,
    last_name,
    first_name,
    middle_name;