CREATE OR ALTER PROCEDURE dbo.sp_InsertScheduleSemistacionar
(
    @GroupName          nvarchar(50),
    @DisciplineName     nvarchar(150),
    @TeacherFIO         nvarchar(150),               
    @StartDate          date,
    @EndDate            date           = NULL,
    @WeeksCount         int            = NULL,
    @DaysPerWeek        tinyint        = 3,          
    @PairsPerDay        tinyint        = 3,
    @StartTime          time           = '09:00:00',
    @PairDurationMin    int            = 90,
    @BreakBetweenPairs  int            = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @GroupID        int            = NULL,
        @DisciplineID   smallint       = NULL,
        @TeacherID      int            = NULL,
        @CurrentDate    date,
        @EndDateCalc    date,
        @InsertedCount  int            = 0,
        @SkippedCount   int            = 0,
        @CurrentTime    time,
        @DayName        nvarchar(20);

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

    -- 3. Преподаватель — обязательно
    IF @TeacherFIO IS NULL OR TRIM(@TeacherFIO) = ''
    BEGIN
        RAISERROR(N'Параметр @TeacherFIO обязателен и не может быть пустым.', 16, 1);
        RETURN;
    END

    SELECT TOP 1 @TeacherID = teacher_id
    FROM Teachers
    WHERE 
        first_name  LIKE '%' + @TeacherFIO + '%'
        OR last_name LIKE '%' + @TeacherFIO + '%'
        OR (first_name + N' ' + ISNULL(last_name, '')) LIKE '%' + @TeacherFIO + '%'
        OR (last_name  + N' ' + ISNULL(first_name, '')) LIKE '%' + @TeacherFIO + '%'
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

    -- 4. Определяем конечную дату
    IF @EndDate IS NOT NULL
        SET @EndDateCalc = @EndDate;
    ELSE IF @WeeksCount IS NOT NULL
        SET @EndDateCalc = DATEADD(WEEK, @WeeksCount, @StartDate);
    ELSE
    BEGIN
        RAISERROR(N'Укажите либо @EndDate, либо @WeeksCount.', 16, 1);
        RETURN;
    END

    -- 5. Вставка
    BEGIN TRY
        BEGIN TRANSACTION;

        SET @CurrentDate = @StartDate;

        WHILE @CurrentDate <= @EndDateCalc
        BEGIN
            SET @DayName = LOWER(DATENAME(WEEKDAY, @CurrentDate));  -- 'понедельник', 'вторник' и т.д.

            DECLARE @IsStudyDay bit = 0;

            -- Надёжная проверка по названию дня (независимо от @@DATEFIRST)
            IF @DaysPerWeek = 2 
                AND @DayName IN (N'понедельник', N'среда')
                SET @IsStudyDay = 1;

            IF @DaysPerWeek = 3 
                AND @DayName IN (N'понедельник', N'среда', N'четверг')
                SET @IsStudyDay = 1;

            IF @IsStudyDay = 0
            BEGIN
                SET @SkippedCount += 1;
                GOTO NextDay;

            IF @DaysPerWeek = 1  -- новый код для "только суббота"
    AND LOWER(DATENAME(WEEKDAY, @CurrentDate)) IN (N'суббота', N'saturday')
    SET @IsStudyDay = 1;
            END

            SET @CurrentTime = @StartTime;

            DECLARE @p tinyint = 1;
            WHILE @p <= @PairsPerDay
            BEGIN
                IF NOT EXISTS (
                    SELECT 1 
                    FROM Schedule 
                    WHERE [group] = @GroupID
                      AND [date]  = @CurrentDate
                      AND [time]  = @CurrentTime
                )
                BEGIN
                    INSERT INTO Schedule
                    (
                        [group], discipline, teacher,
                        [date], [time], spent
                    )
                    VALUES
                    (
                        @GroupID, @DisciplineID, @TeacherID,
                        @CurrentDate, @CurrentTime, 0
                    );

                    SET @InsertedCount += 1;
                END

                SET @CurrentTime = DATEADD(MINUTE, @PairDurationMin + @BreakBetweenPairs, @CurrentTime);
                SET @p += 1;
            END

            NextDay:
            SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
        END

        COMMIT TRANSACTION;

        -- Отчёт
        PRINT N'=============================================================';
        PRINT N'Добавлено пар:       ' + CAST(@InsertedCount AS varchar(10));
        IF @SkippedCount > 0
            PRINT N'Пропущено дней:     ' + CAST(@SkippedCount AS varchar(10));
        PRINT N'Период:             ' + CONVERT(nvarchar(10), @StartDate, 104) 
                   + N' – ' + CONVERT(nvarchar(10), @EndDateCalc, 104);
        PRINT N'Группа:             ' + @GroupName;
        PRINT N'Дисциплина ID:      ' + CAST(@DisciplineID AS nvarchar(10));
        PRINT N'Преподаватель ID:   ' + CAST(@TeacherID AS nvarchar(10));
        PRINT N'=============================================================';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO