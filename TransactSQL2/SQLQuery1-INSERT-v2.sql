--SQLQuery1-INSERT-v2.sql
USE SPU_411_Import;
SET NOCOUNT ON;

DECLARE @group      INT     = (SELECT group_id     FROM Groups      WHERE group_name = N'SPU 411');
DECLARE @discipline SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE N'Процедурное%C++');
DECLARE @teacher    INT     = (SELECT teacher_id   FROM Teachers    WHERE first_name LIKE N'Олег');

DECLARE @start_date DATE = '20241026';
DECLARE @end_date   DATE = '20260117';
DECLARE @start_time TIME = '10:00:00';

DECLARE @cur_date DATE = @start_date;
DECLARE @inserted INT = 0;

WHILE @cur_date <= @end_date
BEGIN
    DECLARE @t1 TIME = @start_time;
    DECLARE @t2 TIME = DATEADD(MINUTE, 95, @t1);
    DECLARE @t3 TIME = DATEADD(MINUTE, 95, @t2);

    INSERT Schedule ([group], discipline, teacher, [date], [time], spent)
    VALUES (@group, @discipline, @teacher, @cur_date, @t1, 1);

    INSERT Schedule ([group], discipline, teacher, [date], [time], spent)
    VALUES (@group, @discipline, @teacher, @cur_date, @t2, 1);

    INSERT Schedule ([group], discipline, teacher, [date], [time], spent)
    VALUES (@group, @discipline, @teacher, @cur_date, @t3, 1);

    SET @inserted += 3;

    SET @cur_date = DATEADD(DAY, 7, @cur_date);
END

PRINT 'Добавлено пар: ' + CAST(@inserted AS varchar(10));
PRINT 'Последняя дата: ' + CONVERT(varchar(10), DATEADD(DAY, -7, @cur_date), 104);