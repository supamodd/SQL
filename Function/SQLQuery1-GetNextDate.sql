-- SQLQuery1-GetNextDate
USE SPU_411_Import;
GO

ALTER FUNCTION GetNextDate (@group_name AS NVARCHAR(24))
RETURNS DATE
AS
BEGIN
    DECLARE @group_id INT = (SELECT group_id FROM Groups WHERE group_name = @group_name);
    DECLARE @learning_days TINYINT = (SELECT weekdays FROM Groups WHERE group_id = @group_id);
    DECLARE @last_date DATE = dbo.GetLastDate(@group_name);
    DECLARE @start_date DATE = (SELECT start_date FROM Groups WHERE group_id = @group_id);

    IF @group_id IS NULL
        RETURN NULL;

    DECLARE @current_date DATE;
    IF @last_date IS NULL
        SET @current_date = @start_date;
    ELSE
        SET @current_date = DATEADD(DAY, 1, @last_date);

    WHILE 1 = 1
    BEGIN
        DECLARE @weekday TINYINT = DATEPART(WEEKDAY, @current_date);
        DECLARE @is_holiday BIT = 0;

        -- Проверка на праздник/каникулы
        DECLARE @year INT = YEAR(@current_date);
        DECLARE @month TINYINT = MONTH(@current_date);
        DECLARE @day TINYINT = DAY(@current_date);

        IF EXISTS (
            SELECT 1 FROM dbo.Holidays h
            WHERE h.month = @month AND h.day = @day
        )
            SET @is_holiday = 1;

        DECLARE @h_id TINYINT, @h_month TINYINT, @h_day TINYINT, @duration TINYINT;
        DECLARE holiday_cursor CURSOR FOR
            SELECT holiday_id, month, day, duration FROM dbo.Holidays WHERE duration > 1;
        OPEN holiday_cursor;
        FETCH NEXT FROM holiday_cursor INTO @h_id, @h_month, @h_day, @duration;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @h_date DATE = DATEFROMPARTS(@year, @h_month, @h_day);
            DECLARE @end_h_date DATE = DATEADD(DAY, @duration - 1, @h_date);
            IF @current_date BETWEEN @h_date AND @end_h_date
                SET @is_holiday = 1;
            FETCH NEXT FROM holiday_cursor INTO @h_id, @h_month, @h_day, @duration;
        END
        CLOSE holiday_cursor;
        DEALLOCATE holiday_cursor;

        IF (POWER(2, @weekday - 1) & @learning_days) > 0 AND @is_holiday = 0
            RETURN @current_date;

        SET @current_date = DATEADD(DAY, 1, @current_date);
    END

    RETURN NULL;
END
GO