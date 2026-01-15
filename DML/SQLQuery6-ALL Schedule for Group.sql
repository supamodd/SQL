USE SPU_411_Import;

SELECT
    d.discipline_id,
    d.discipline_name,
    ROW_NUMBER() OVER (ORDER BY d.discipline_name) AS [порядок]
FROM Disciplines d
INNER JOIN DisciplinesDirectionsRelation r 
    ON d.discipline_id = r.discipline
WHERE r.direction = (
    SELECT [direction] 
    FROM Groups 
    WHERE group_id = 777
)
ORDER BY d.discipline_name;