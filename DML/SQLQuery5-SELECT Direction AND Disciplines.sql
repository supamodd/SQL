--SQLQuery5-SELECT Direction AND Disciplines
USE SPU_411_Import;

DECLARE @direction_id INT = 1;

SELECT 
    dir.direction_id,
    dir.direction_name                AS [Направление],
    disc.discipline_id,
    disc.discipline_name              AS [Дисциплина]
FROM Directions dir
INNER JOIN DisciplinesDirectionsRelation rel 
    ON dir.direction_id = direction_id
INNER JOIN Disciplines disc 
    ON rel.discipline = disc.discipline_id
WHERE dir.direction_id = @direction_id
ORDER BY
    disc.discipline_name;