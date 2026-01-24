--SQLQuery3-ADD Day of Week
USE SPU_411_Import;


SELECT 
    CONVERT(varchar(10), [date], 104)                AS [Дата],
    
    CASE DATEPART(WEEKDAY, [date])
        WHEN 1 THEN N'Воскресенье'
        WHEN 2 THEN N'Понедельник'
        WHEN 3 THEN N'Вторник'
        WHEN 4 THEN N'Среда'
        WHEN 5 THEN N'Четверг'
        WHEN 6 THEN N'Пятница'
        WHEN 7 THEN N'Суббота'
    END                                                AS [День недели],
    
    CONVERT(varchar(5), [time], 108)                 AS [Время],
    
    discipline_name                                  AS [Дисциплина],
    
    TRIM(first_name + ' ' + ISNULL(last_name, '')) AS [Преподаватель],
    
    group_name                                       AS [Группа],
    
    CASE spent 
        WHEN 1 THEN N'Проведена' 
        ELSE N'—' 
    END                                                AS [Статус]

FROM Schedule
INNER JOIN Groups        ON group_id       = [group]
INNER JOIN Disciplines   ON discipline_id  = discipline
INNER JOIN Teachers      ON teacher_id     = teacher

WHERE group_name = N'SPU 411'
  AND [date] BETWEEN '20241026' AND '20260117'
  -- AND d.discipline_name LIKE N'Процедурное%C++'
  -- AND t.first_name LIKE N'Олег'

ORDER BY 
    [date] ASC,
    [time] ASC;