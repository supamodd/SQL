--SQLQuery3-INSERT NEW Schedule semistacionar
USE SPU_411_Import;
GO
ALTER PROCEDURE sp_InsertScheduleSemistacionar
    @group_name AS NVARCHAR(24),
    --@discipline_name AS NVARCHAR(150),
    @discipline_id AS SMALLINT,
    @teacher AS NVARCHAR(50)
AS
BEGIN
    DECLARE @group_id AS INT = (SELECT group_id FROM Groups WHERE group_name = @group_name);
    DECLARE @discipline SMALLINT = @discipline_id; -- redundant, but ok
    --DECLARE @discipline_id AS SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE @discipline_name);
    DECLARE @teacher_id AS SMALLINT = (SELECT teacher_id FROM Teachers WHERE last_name LIKE '%' + @teacher + '%'); -- added wildcards for partial match

    IF @group_id IS NULL
    BEGIN
        RAISERROR('Группа "%s" не найдена.', 16, 1, @group_name);
        RETURN;
    END

    IF @teacher_id IS NULL
    BEGIN
        RAISERROR('Учитель с фамилией "%s" не найден в таблице Teachers.', 16, 1, @teacher);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Schedule WHERE [group] = @group_id AND discipline = @discipline_id)
    BEGIN
        RAISERROR('Дисциплина с ID %d уже существует в расписании для группы "%s". Повторная вставка запрещена.', 16, 1, @discipline_id, @group_name);
        RETURN;
    END

    --DECLARE @start_date AS DATE = dbo.GetNextDate(@group_name);
    DECLARE @date AS DATE = dbo.GetLastDate(@group_name);
    DECLARE @start_time AS TIME = (SELECT start_time FROM Groups WHERE group_id = @group_id);
    DECLARE @time AS TIME = @start_time;
    DECLARE @number_of_lessons AS TINYINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_id);
    IF @date IS NULL SET @date = (SELECT start_date FROM Groups WHERE group_id = @group_id);
    DECLARE @lesson_number AS INT = 1;
    PRINT '-------------------------------------';
    PRINT @group_id;
    PRINT @discipline_id;
    PRINT @teacher;
    PRINT @date;
    PRINT @time;
    PRINT @lesson_number;
    PRINT '-------------------------------------';
    WHILE @lesson_number <= @number_of_lessons
    BEGIN
        IF dbo.GetLastDate(@group_name) IS NOT NULL SET @date = dbo.GetNextDate (@group_name);
        SET @time = @start_time;
        EXEC sp_Insertlesson @group_id,@discipline_id,@teacher_id,@date,@time OUTPUT,@lesson_number OUTPUT;
        --SET @time = DATEADD (MINUTE,95, @time);
        EXEC sp_Insertlesson @group_id,@discipline_id,@teacher_id,@date,@time OUTPUT,@lesson_number OUTPUT;
        --SET @time = DATEADD (MINUTE,95, @time);
        EXEC sp_Insertlesson @group_id,@discipline_id,@teacher_id,@date,@time OUTPUT,@lesson_number OUTPUT;
        PRINT @lesson_number;
    END
END