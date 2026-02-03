-- SQLQuery1-GetStartDate
USE SPU_411_Import;
GO

CREATE OR ALTER FUNCTION GetStartDate(@group_name AS NVARCHAR(24))
RETURNS DATE
BEGIN
    DECLARE @group_id AS INT = (SELECT group_id FROM Groups WHERE group_name=@group_name);
    DECLARE @start_date AS DATE = NULL;
    IF dbo.GetLastDate(@group_name) IS NULL
        SET @start_date = (SELECT start_date FROM Groups WHERE group_id=@group_id);
    ELSE
        SET @start_date = dbo.GetNextDate(@group_name);
    RETURN @start_date;
END
GO