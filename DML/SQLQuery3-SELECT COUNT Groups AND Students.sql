--SQLQuery3-SELECT Count Group and Students
USE SPU_411_Import

SELECT 
			direction_name		AS N'Направления обучения',
			COUNT(DISTINCT group_name)	AS N'Количество групп',  
			COUNT( stud_id)		AS N'Количество студентов'
FROM		Students, Groups, Directions
WHERE		direction	=	direction_id
AND			[group]		=	group_id
--AND			COUNT(group_name) < 5  where 
GROUP BY	direction_name
--HAVING		COUNT(group_name) < 5 --having 
ORDER BY	N'Количество групп'	
;