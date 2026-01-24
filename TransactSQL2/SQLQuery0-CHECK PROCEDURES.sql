--------------------------------------------------------
EXEC sp_SelectSchedule @group_name = N'SPU 411';

---------------------------------------------------
EXEC sp_SelectSchedule 
    @group_name      = N'SPU 411',
    @discipline_name = N'C++';

-----------------------------------------------------
EXEC sp_SelectSchedule 
    @group_name      = N'SPU 411',
    @discipline_name = N'Процедурное',
    @date_from       = '2024-11-01',
    @date_to         = '2026-06-30';