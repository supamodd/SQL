--------------------------------------------------------
EXEC sp_SelectSchedule 
@group_name = N'SPU 411';

---------------------------------------------------
--EXEC sp_SelectSchedule 
--    @group_name      = N'SPU 411',
--    @discipline_name = N'C++';

-------------------------------------------------------
--EXEC sp_SelectSchedule 
--    @group_name      = N'SPU 411',
--    @discipline_name = N'Процедурное',
--    @date_from       = '2024-11-01',
--    @date_to         = '2026-06-30';
EXEC dbo.sp_InsertScheduleSemistacionar
    @GroupName         = N'SPU 411',
    @DisciplineName    = N'Процедурное программирование на языке C++',
    @TeacherFIO        = N'Олег',                    -- или N'Ковтун', если поиск не сработает
    @StartDate         = '20250901',                 -- 1 сентября 2025
    @EndDate           = '20260131',                 -- до 31 января 2026
    @WeeksCount        = NULL,                       -- не нужен
    @DaysPerWeek       = 1,                          -- измени на 1 после фикса процедуры
    @PairsPerDay       = 3,
    @StartTime         = '10:00:00',
    @PairDurationMin   = 95,
    @BreakBetweenPairs = 10;