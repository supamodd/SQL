-- SQLQuery5-SELECT Students IN Group
USE SPU_411_Import;

SELECT 
    direction_name                                          AS N'Направление',
    group_name                                              AS N'Группа',
    COUNT(stud_id)                                          AS N'Кол-во студентов'

FROM Directions
LEFT JOIN Groups ON direction = direction_id
LEFT JOIN Students ON [group] = group_id

GROUP BY direction_name, group_name, group_id

UNION ALL

-- Группы, у которых вообще нет направления (если такие есть в базе)
SELECT 
    N'(направление не указано)'                               AS N'Направление',
    group_name                                              AS N'Группа',
    COUNT(stud_id)                                          AS N'Кол-во студентов'

FROM Groups
LEFT JOIN Directions ON direction_id = direction
LEFT JOIN Students ON [group] = group_id

WHERE direction_id IS NULL

GROUP BY group_name, group_id

ORDER BY 1, 2
;