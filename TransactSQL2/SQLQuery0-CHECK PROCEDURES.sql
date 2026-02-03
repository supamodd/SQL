
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

-- Тестовый вызов процедуры для проверки группы PV_319 (3 дня в неделю: Вт, Чт, Сб с 18:30)
EXEC dbo.sp_InsertScheduleSemistacionar
    @GroupName = N'SPU 411',
    @DisciplineName = N'Процедурное программирование на языке C++',  -- или любая другая дисциплина
    @TeacherFIO = N'Олег',
    @StartDate = '20250901',
    @EndDate = NULL,
    @WeeksCount = 20,
    @DaysPerWeek = 3,  -- 3 дня в неделю
    @PairsPerDay = 1,  -- Одна пара (с 18:30 до 21:30, предположим длительность 180 мин без перерыва)
    @StartTime = '18:30:00',
    @PairDurationMin = 180,
    @BreakBetweenPairs = 0;