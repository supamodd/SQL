--SQLQuery5-SELECT Teachers IN Disciplines
USE SPU_411_Import;

SELECT 
    d.discipline_name          AS [Дисциплина],
    COUNT(DISTINCT t.teacher_id) AS [Количество преподавателей]
FROM Disciplines d
LEFT JOIN TeachersDisciplinesRelation td ON discipline_id = d.discipline_id
LEFT JOIN Teachers t         ON t.teacher_id = teacher_id
GROUP BY d.discipline_name, d.discipline_id
ORDER BY 
    [Количество преподавателей] DESC,
    d.discipline_name;