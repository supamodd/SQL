--SQLQuery2-Discipline AND Schedules
USE SPU_411_Import

SET NOCOUNT ON;

SET DATEFIRST 1; 


DECLARE @group_id INT = 319;                          
DECLARE @default_teacher_id INT = 1;                 

DECLARE @start_date DATE = '2025-09-02';              
DECLARE @start_time TIME = '18:30:00';
DECLARE @lessons_per_day INT = 3;
DECLARE @minutes_per_lesson INT = 95;

DECLARE @disciplines TABLE (
    ord           INT IDENTITY(1,1),
    discipline_id SMALLINT
);

INSERT INTO @disciplines (discipline_id)
SELECT d.discipline_id
FROM dbo.Disciplines d
WHERE d.discipline_name IN (
    N'UML и паттерны проектирования',
    N'Язык программирования C#',
    N'Разработка Windows-приложений на языке C++',
    N'Разработка Windows-приложений на языке C#',
    N'Теория баз данных, программирование MS SQL Server',
    N'Технология доступа к данным ADO.NET',
    N'Системное программирование',
    N'Сетевое программирование'
)
ORDER BY CASE d.discipline_name
    WHEN N'UML и паттерны проектирования'                              THEN 1
    WHEN N'Язык программирования C#'                                   THEN 2
    WHEN N'Разработка Windows-приложений на языке C++'                 THEN 3
    WHEN N'Разработка Windows-приложений на языке C#'                  THEN 4
    WHEN N'Теория баз данных, программирование MS SQL Server'          THEN 5
    WHEN N'Технология доступа к данным ADO.NET'                        THEN 6
    WHEN N'Системное программирование'                                 THEN 7
    WHEN N'Сетевое программирование'                                   THEN 8
    ELSE 999
END;


DECLARE @current_date    DATE  = @start_date;
DECLARE @lesson_number   INT   = 1;
DECLARE @current_time    TIME;
DECLARE @day_of_week     INT;
DECLARE @inserted_count  INT   = 0;

WHILE @lesson_number <= 8
BEGIN
    SET @day_of_week = DATEPART(WEEKDAY, @current_date);

    IF @day_of_week IN (3,5,7)
    BEGIN
        SET @current_time = @start_time;

        DECLARE @pair INT = 1;
        WHILE @pair <= @lessons_per_day AND @lesson_number <= 8
        BEGIN
            DECLARE @current_discipline_id SMALLINT;
            SELECT @current_discipline_id = discipline_id 
            FROM @disciplines 
            WHERE ord = @lesson_number;

            BEGIN TRY
                INSERT INTO Schedule
                    ([group], discipline, teacher, [date], [time], spent)
                VALUES
                    (@group_id,
                     @current_discipline_id,
                     @default_teacher_id,     
                     @current_date,
                     @current_time,
                     IIF(@current_date < CAST(GETDATE() AS DATE), 1, 0));

                SET @inserted_count = @inserted_count + 1;
            END TRY
            BEGIN CATCH
                PRINT 'Ошибка вставки на уроке #' + CAST(@lesson_number AS varchar(10));
                PRINT ERROR_MESSAGE();
                RETURN;
            END CATCH

            SET @current_time = DATEADD(MINUTE, @minutes_per_lesson, @current_time);
            SET @lesson_number = @lesson_number + 1;
            SET @pair = @pair + 1;
        END
    END

    SET @current_date = DATEADD(DAY, 1, @current_date);
END

PRINT 'Успешно вставлено: ' + CAST(@inserted_count AS varchar(10)) + ' занятий.';
PRINT 'Последняя дата: ' + CONVERT(varchar(10), @current_date, 104);