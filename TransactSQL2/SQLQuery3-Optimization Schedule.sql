--SQLQuery3-Optimization Schedule
USE SPU_411_Import;

SELECT 
    CONVERT(varchar(10), [date], 104)                AS Дата,
    
    CASE DATEPART(dw, [date]) 
        WHEN 1 THEN N'Вс'
        WHEN 2 THEN N'Пн'
        WHEN 3 THEN N'Вт'
        WHEN 4 THEN N'Ср'
        WHEN 5 THEN N'Чт'
        WHEN 6 THEN N'Пт'
        WHEN 7 THEN N'Сб'
    END                                                AS День,

    CONVERT(varchar(5), [time], 108)                 AS Время,
    
    discipline_name                                  AS Дисциплина,
    
    RTRIM(first_name) + ' ' + RTRIM(ISNULL(last_name, '')) 
                                                       AS Преподаватель,

    CASE spent 
        WHEN 1 THEN N'?' 
        ELSE N'—' 
    END                                                AS Статус

FROM Schedule
INNER JOIN Groups        WITH (NOLOCK)  ON group_id      = [group]
INNER JOIN Disciplines   WITH (NOLOCK)  ON discipline_id = discipline
INNER JOIN Teachers      WITH (NOLOCK)  ON teacher_id    = teacher

WHERE [group] = (SELECT group_id FROM Groups WHERE group_name = N'PV_319')
  AND [date] >= '20241026'
  AND [date] <= '20260117'

ORDER BY [date], [time]
OPTION (RECOMPILE);