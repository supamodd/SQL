USE SPU_411_Import;
GO

CREATE OR ALTER PROCEDURE dbo.sp_InsertScheduleSemistacionar
(
    @GroupName nvarchar(50),
    @DisciplineName nvarchar(150),
    @TeacherFIO nvarchar(150),
    @StartDate date,
    @EndDate date = NULL,
    @WeeksCount int = NULL,
    @DaysPerWeek tinyint = 3,
    @PairsPerDay tinyint = 3,
    @StartTime time = '09:00:00',
    @PairDurationMin int = 90,
    @BreakBetweenPairs int = 10
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @GroupID int = NULL,
        @DisciplineID smallint = NULL,
        @TeacherID int = NULL,
        @CurrentDate date,
        @EndDateCalc date,
        @InsertedCount int = 0,
        @SkippedCount int = 0,
        @CurrentTime time,
        @DayName nvarchar(20);

    SELECT @GroupID = group_id
    FROM Groups
    WHERE group_name = @GroupName;
    IF @GroupID IS NULL
    BEGIN
        RAISERROR(N'Группа "%s" не найдена.', 16, 1, @GroupName);
        RETURN;
    END
    SELECT @DisciplineID = discipline_id
    FROM Disciplines
    WHERE discipline_name LIKE '%' + @DisciplineName + '%';
    IF @DisciplineID IS NULL
    BEGIN
        RAISERROR(N'Дисциплина "%s" не найдена (по LIKE).', 16, 1, @DisciplineName);
        RETURN;
    END
    IF @TeacherFIO IS NULL OR TRIM(@TeacherFIO) = ''
    BEGIN
        RAISERROR(N'Параметр @TeacherFIO обязателен и не может быть пустым.', 16, 1);
        RETURN;
    END
    SELECT TOP 1 @TeacherID = teacher_id
    FROM Teachers
    WHERE
        first_name LIKE '%' + @TeacherFIO + '%'
        OR last_name LIKE '%' + @TeacherFIO + '%'
        OR (first_name + N' ' + ISNULL(last_name, '')) LIKE '%' + @TeacherFIO + '%'
        OR (last_name + N' ' + ISNULL(first_name, '')) LIKE '%' + @TeacherFIO + '%'
    ORDER BY LEN(first_name + last_name) ASC;
    IF @TeacherID IS NULL
    BEGIN
        PRINT N'Преподаватель по запросу "' + @TeacherFIO + N'" не найден.';
        PRINT N'Похожие записи (для справки):';
       
        SELECT TOP 10
            teacher_id,
            first_name,
            last_name,
            first_name + N' ' + ISNULL(last_name, N'') AS Полное_имя
        FROM dbo.Teachers
        WHERE first_name LIKE '%' + @TeacherFIO + '%'
           OR last_name LIKE '%' + @TeacherFIO + '%'
        ORDER BY first_name, last_name;
        RAISERROR(N'Преподаватель не найден. Выберите из списка выше.', 16, 1);
        RETURN;
    END
    PRINT N'Преподаватель найден ? ID ' + CAST(@TeacherID AS nvarchar(10));
    IF @EndDate IS NOT NULL
        SET @EndDateCalc = @EndDate;
    ELSE IF @WeeksCount IS NULL
        BEGIN
            RAISERROR(N'Укажите либо @EndDate, либо @WeeksCount.', 16, 1);
            RETURN;
        END
    ELSE
        SET @EndDateCalc = DATEADD(WEEK, @WeeksCount, @StartDate);
    BEGIN TRY
        BEGIN TRANSACTION;
                                                                 -- Вызов GetStartDate для начальной даты
        SET @CurrentDate = dbo.GetStartDate(@GroupName);
        IF @CurrentDate < @StartDate
            SET @CurrentDate = @StartDate;
        WHILE @CurrentDate <= @EndDateCalc
        BEGIN
                                                                -- Проверка на праздник через таблицу Holidays
            DECLARE @is_holiday BIT = 0;
            DECLARE @month TINYINT = MONTH(@CurrentDate);
            DECLARE @day TINYINT = DAY(@CurrentDate);
            IF EXISTS (
                SELECT 1 FROM dbo.Holidays h
                WHERE h.month = @month AND h.day = @day
            )
                SET @is_holiday = 1;

                                                                 -- Для каникул (проверка диапазона)
            DECLARE @h_id TINYINT, @h_month TINYINT, @h_day TINYINT, @duration TINYINT;
            DECLARE holiday_cursor CURSOR FOR
                SELECT holiday_id, month, day, duration FROM dbo.Holidays WHERE duration > 1;
            OPEN holiday_cursor;
            FETCH NEXT FROM holiday_cursor INTO @h_id, @h_month, @h_day, @duration;
            WHILE @@FETCH_STATUS = 0
            BEGIN
                DECLARE @h_date DATE = DATEFROMPARTS(YEAR(@CurrentDate), @h_month, @h_day);
                DECLARE @end_h_date DATE = DATEADD(DAY, @duration - 1, @h_date);
                IF @CurrentDate BETWEEN @h_date AND @end_h_date
                    SET @is_holiday = 1;
                FETCH NEXT FROM holiday_cursor INTO @h_id, @h_month, @h_day, @duration;
            END
            CLOSE holiday_cursor;
            DEALLOCATE holiday_cursor;

                                                     -- Вызов GetNextDay для проверки учебного дня
            DECLARE @next_day TINYINT = dbo.GetNextDay(@GroupName);
            IF DATEPART(WEEKDAY, @CurrentDate) <> @next_day OR @is_holiday = 1
            BEGIN
                SET @SkippedCount += 1;
                                                    -- Вызов GetNextDate для перехода к следующей дате
                SET @CurrentDate = dbo.GetNextDate(@GroupName);
                CONTINUE;
            END

            SET @CurrentTime = @StartTime;
            DECLARE @p tinyint = 1;
            WHILE @p <= @PairsPerDay
            BEGIN
                IF NOT EXISTS (
                    SELECT 1
                    FROM Schedule
                    WHERE [group] = @GroupID
                      AND [date] = @CurrentDate
                      AND [time] = @CurrentTime
                )
                BEGIN
                    DECLARE @spent BIT = IIF(@CurrentDate <= GETDATE(), 1, 0);
                    INSERT INTO Schedule
                    (
                        [group], discipline, teacher,
                        [date], [time], spent
                    )
                    VALUES
                    (
                        @GroupID, @DisciplineID, @TeacherID,
                        @CurrentDate, @CurrentTime, @spent
                    );
                    SET @InsertedCount += 1;
                END
                SET @CurrentTime = DATEADD(MINUTE, @PairDurationMin + @BreakBetweenPairs, @CurrentTime);
                SET @p += 1;
            END
                                                            -- Вызов GetNextDate для следующей итерации
            SET @CurrentDate = dbo.GetNextDate(@GroupName);
        END
        COMMIT TRANSACTION;
        -- Отчёт
        PRINT N'=============================================================';
        PRINT N'Добавлено пар: ' + CAST(@InsertedCount AS varchar(10));
        IF @SkippedCount > 0
            PRINT N'Пропущено дней: ' + CAST(@SkippedCount AS varchar(10));
        PRINT N'Период: ' + CONVERT(nvarchar(10), @StartDate, 104)
                   + N' – ' + CONVERT(nvarchar(10), @EndDateCalc, 104);
        PRINT N'Группа: ' + @GroupName;
        PRINT N'Дисциплина ID: ' + CAST(@DisciplineID AS nvarchar(10));
        PRINT N'Преподаватель ID: ' + CAST(@TeacherID AS nvarchar(10));
        PRINT N'=============================================================';

        -- Вывод расписания после вставки
        SELECT
            CONVERT(varchar(10), s.[date], 104) AS Дата,
            UPPER(LEFT(DATENAME(WEEKDAY, s.[date]), 2)) AS День,
            CONVERT(varchar(5), s.[time], 108) AS Время,
            d.discipline_name AS Дисциплина,
            t.last_name + N' ' + LEFT(t.first_name, 1) + N'.' + LEFT(t.middle_name, 1) + N'.' AS Преподаватель,
            CASE s.spent
                WHEN 1 THEN N'? Проведено'
                WHEN 0 THEN N'– Запланировано'
                ELSE N'?'
            END AS Статус
        FROM Schedule s
        INNER JOIN Groups g ON s.[group] = g.group_id
        INNER JOIN Disciplines d ON s.discipline = d.discipline_id
        INNER JOIN Teachers t ON s.teacher = t.teacher_id
        WHERE g.group_name = @GroupName
          AND s.[date] >= @StartDate
          AND s.[date] <= @EndDateCalc
        ORDER BY s.[date] ASC, s.[time] ASC;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO