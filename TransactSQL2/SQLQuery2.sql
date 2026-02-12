--SQLQuery1-INSERT ScheduleSemi PROCEDURE.sql
USE SPU_411_Import;
GO
CREATE OR ALTER PROCEDURE sp_InsertScheduleSemistacionar
		 @group_name		AS		NVARCHAR(24)
		,@discipline_name	AS		NVARCHAR(150)
		,@teacher			AS		NVARCHAR(50)
AS
BEGIN
	DECLARE @group_id		AS	INT		=	(SELECT group_id		FROM Groups		 WHERE group_name=@group_name);
	DECLARE @discipline_id	AS	SMALLINT=	(SELECT discipline_id	FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @teacher_id		AS	SMALLINT=	(SELECT teacher_id		FROM Teachers	 WHERE last_name = @teacher);
	--DECLARE @start_date		AS	DATE	=	???;
	--DECLARE @date			AS	DATE	=	@start_date;
	DECLARE @start_time		AS	TIME	=	(SELECT start_time		FROM Groups		 WHERE group_id=@group_id);
END