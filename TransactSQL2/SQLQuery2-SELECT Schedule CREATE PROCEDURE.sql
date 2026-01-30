--SQLQuery2-SELECT SelectSchedule CREATE PROCEDURE.sql
USE SPU_411_Import;
GO

ALTER PROCEDURE sp_SelectSchedule
    @group_name     NVARCHAR(50),
    @discipline_name NVARCHAR(150) = N'%',
    @date_from      DATE = NULL,               
    @date_to        DATE = NULL                 
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        group_name                              AS [Группа],
        
        CONVERT(varchar(10), [date], 104)       AS [Дата],
        
        UPPER(LEFT(DATENAME(WEEKDAY, [date]), 2)) 
                                                  AS [День],
        
        CONVERT(varchar(5), [time], 108)        AS [Время],
        
        discipline_name                         AS [Дисциплина],
        
        NULLIF(
            TRIM(
                ISNULL(last_name + N' ', '') +
                ISNULL(LEFT(first_name, 1) + N'. ', '') +
                ISNULL(LEFT(middle_name, 1) + N'.', '')
            ),
            ''
        )                                         AS [Преподаватель],
        
        CASE spent
            WHEN 1 THEN N'? Проведено'
            WHEN 0 THEN N'– Запланировано'
            ELSE        N'?'
        END                                       AS [Статус]

    FROM Schedule
    INNER JOIN Groups       ON group_id      = [group]
    INNER JOIN Disciplines  ON discipline_id = discipline
    LEFT  JOIN Teachers     ON teacher_id    = teacher

    WHERE group_name = @group_name
    
      AND discipline_name LIKE '%' + @discipline_name + '%'
      
      AND (@date_from IS NULL OR [date] >= @date_from)
      AND (@date_to   IS NULL OR [date] <= @date_to)

    ORDER BY 
        [date] ASC,
        [time] ASC;

    DECLARE @cnt int = @@ROWCOUNT;

    IF @cnt = 0
        PRINT N'По заданным параметрам расписание не найдено.'
    ELSE
        PRINT N'Найдено записей: ' + CAST(@cnt AS varchar(10)) + N' шт.';
END