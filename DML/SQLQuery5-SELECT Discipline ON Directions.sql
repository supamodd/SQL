USE SPU_411_Import; 

DECLARE @discipline_id INT = 11;   -- нужный ID дисциплины

SELECT 
    direction_id,
    direction_name                  AS Направление,
    dis.discipline_name               AS Дисциплина
FROM Disciplines dis
INNER JOIN DisciplinesDirectionsRelation dd 
    ON dis.discipline_id = discipline
INNER JOIN Directions 
    ON direction_id = direction_id
WHERE dis.discipline_id = @discipline_id
ORDER BY direction_name;