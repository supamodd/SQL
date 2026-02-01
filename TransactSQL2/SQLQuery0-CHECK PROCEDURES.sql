
---------------------------------------------------
EXEC sp_SelectSchedule
    @group_name      = N'SPU 411',
    @discipline_name = N'C++';

-------------------------------------------------------
--EXEC sp_SelectSchedule 
--    @group_name      = N'SPU 411',
--    @discipline_name = N'Процедурное',
--    @date_from       = '2024-11-01',
--    @date_to         = '2026-06-30';
--EXEC dbo.sp_InsertScheduleSemistacionar
--    @GroupName         = N'PV_319',
--    @DisciplineName    = N'Процедурное%C++',
--    @TeacherFIO        = N'Олег',                    
--    @StartDate         = '20250901',                 
--    @EndDate           = '20260131',                 
--    @WeeksCount        = NULL,                       
--    @DaysPerWeek       = 1,                          
--    @PairsPerDay       = 3,
--    @StartTime         = '10:00:00',
--    @PairDurationMin   = 95,
--    @BreakBetweenPairs = 10;
EXEC sp_SelectScheduleFull;