-- SQLQuery2-Holidays
USE SPU_411_Import;
GO

-- Вставка праздников
MERGE INTO dbo.Holidays AS target
USING (
    VALUES 
        (1, N'День народного единства', 1, 11, 4),
        (2, N'Предновогодний выходной', 1, 12, 31),
        (3, N'Новый год', 8, 1, 1),
        (4, N'Рождество Христово', 1, 1, 7),
        (5, N'Перенос выходного (январь)', 3, 1, 9),  
        (6, N'День защитника Отечества', 1, 2, 23),
        (7, N'Международный женский день', 1, 3, 8),
        (8, N'Праздник Весны и Труда', 1, 5, 1),
        (9, N'День Победы', 1, 5, 9),
        (10, N'День России', 1, 6, 12)
) AS source (holiday_id, holiday_name, duration, month, day)
ON target.holiday_id = source.holiday_id
WHEN NOT MATCHED THEN
    INSERT (holiday_id, holiday_name, duration, month, day)
    VALUES (source.holiday_id, source.holiday_name, source.duration, source.month, source.day);
GO