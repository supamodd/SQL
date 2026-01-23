--SQLQuery1-INSERT.sql
USE SPU_411_Import;


DECLARE	@group		AS	INT			=	(SELECT group_id		FROM Groups			WHERE group_name=N'SPU 411');
DECLARE	@discipline	AS	SMALLINT	=	(SELECT discipline_id	FROM Disciplines	WHERE discipline_name LIKE	(N'Процедурное%C++'));
DECLARE	@number_of_lessons	AS	TINYINT	=	(SELECT number_of_lessons	FROM Disciplines	WHERE discipline_id = @discipline);
DECLARE	@lesson_number	AS	INT	=	1;
DECLARE	@teacher		AS	INT	=	(SELECT	teacher_id FROM Teachers	WHERE first_name LIKE(N'Олег'));
DECLARE	@start_date		AS	DATE	=	N'2024-10-26';
DECLARE	@date			AS	DATE	=	@start_date;
DECLARE	@start_time		AS	TIME	=	N'10:00';
DECLARE	@time			AS	TIME	=	@start_time

PRINT(@group)
PRINT(@discipline)
PRINT(@number_of_lessons)
PRINT(@teacher)
PRINT(@date)
PRINT(@start_time);


WHILE	(@lesson_number <= @number_of_lessons)
BEGIN
		PRINT('-----------------------------');
		PRINT (@date);
		----------------------------------------------
		SET @time=@start_time
		INSERT Schedule
		([group], discipline, teacher, [date], [time], spent)
VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date<GETDATE(),1,0 ));
		PRINT (@time);
		SET @lesson_number=@lesson_number+1;
		-----------------------------------------------
		SET @time = DATEADD(MINUTE, 95, @time);
		PRINT (@time);
		INSERT Schedule
		([group], discipline, teacher, [date], [time], spent)
VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date<GETDATE(),1,0));
		SET @lesson_number=@lesson_number+1;
		------------------------------------------------
		SET @time = DATEADD(MINUTE, 95, @time);
		PRINT (@time);
		INSERT Schedule
		([group], discipline, teacher, [date], [time], spent)
VALUES	(@group, @discipline, @teacher, @date, @time, IIF(@date<GETDATE(),1,0 ));
		SET @lesson_number=@lesson_number+1;
		--------------------------------------------------
		SET @date = DATEADD(DAY, 7, @date);

END