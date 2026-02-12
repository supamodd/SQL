--SQLQuery1_PROCEDURE INSERT Lesson.sql
SET DATEFIRST 1;
USE SPU_411_Import;
GO
ALTER PROCEDURE sp_InsertLesson
	 @group				AS	INT
	,@discipline		AS	SMALLINT
	,@teacher			AS	INT
	,@date				AS	DATE
	,@time				AS	TIME		OUTPUT
	,@lesson_number		AS	TINYINT		OUTPUT
AS
BEGIN
	IF NOT EXISTS(SELECT [group] FROM Schedule WHERE [group]=@group AND [date]=@date AND [time]=@time)
	BEGIN
		INSERT Schedule
				([group],discipline,teacher,[date],[time],spent)
		VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date<GETDATE(),1,0));
	END
	SET @time = DATEADD(MINUTE, 95, @time);
	SET @lesson_number = @lesson_number+1;
END