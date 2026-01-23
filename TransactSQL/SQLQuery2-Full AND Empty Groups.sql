USE SPU_411_Import

SELECT 
    direction                 AS N'Направления',
    COUNT(DISTINCT group_id) AS N'Всего групп',
    
    COUNT(DISTINCT CASE 
        WHEN [group] IS NULL THEN group_id 
        END) AS N'Пустые группы',  
    
    COUNT(DISTINCT CASE 
        WHEN [group] IS NOT NULL THEN group_id 
        END) AS N'Заполненные группы'   
    
FROM Groups
LEFT JOIN Schedule s ON [group] = group_id
GROUP BY direction
ORDER BY direction;