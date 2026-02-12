
---------------------------------------------------
--EXEC sp_SelectSchedule
--    @group_name      = N'SPU 411',
--    @discipline_name = N'C++';

-------------------------------------------------------

---- Тестовый вызов процедуры для проверки (пример для группы SPU 411, дисциплины C++, преподавателя Олег, с 1 сентября 2025 на 20 недель)
--EXEC dbo.sp_InsertScheduleSemistacionar
--    @GroupName = N'PV_319',
--    @DisciplineName = N'Процедурное программирование на языке C++',
--    @TeacherFIO = N'Олег',
--    @StartDate = '20250901',
--    @EndDate = NULL,
--    @WeeksCount = 20,
--    @DaysPerWeek = 3,
--    @PairsPerDay = 3,
--    @StartTime = '10:00:00',
--    @PairDurationMin = 95,
--    @BreakBetweenPairs = 10;

--EXEC dbo.sp_InsertScheduleSemistacionar
--    @GroupName = N'SPU 411',
--    @DisciplineName = N'Процедурное программирование на языке C++',  -- или любая другая дисциплина
--    @TeacherFIO = N'Олег',
--    @StartDate = '20250901',
--    @EndDate = NULL,
--    @WeeksCount = 20,
--    @DaysPerWeek = 3,  -- 3 дня в неделю
--    @PairsPerDay = 3, 
--    @StartTime = '18:30:00',
--    @PairDurationMin = 180,
--    @BreakBetweenPairs = 0;

--SQLQuery0-CHECK PROCEDURES.sql
USE SPU_411_Import;
SET LANGUAGE N'Russian';


EXEC sp_SelectSchedule N'SPU_411', N'Процедурное%C++';
EXEC sp_InsertScheduleSemistacionar N'SPU 411',2,N'Ковтун';

--EXEC sp_SelectScheduleFull;