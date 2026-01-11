--SQLQuery2-SELECT Students.sql
USE SPU_411_Import;

SELECT
			--last_name		AS	N'Фамилия',
			--first_name		AS	N'Имя',
			--middle_name		AS	N'Отчество',
			FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name)	AS	N'Студент',
			birth_date		AS	N'Дата рождения',
			CAST(DATEDIFF(DAY,birth_date,GETDATE())/365.25 AS INT),
			group_name		AS	N'Группа',
			direction_name	AS	N'Направление обучения'
FROM		Students, Groups, Directions
WHERE		[group]			=	group_id
AND			direction		=	direction_id
AND			direction_name	LIKE N'Разработка%'
ORDER BY	last_name		--DESC	--DESCENDING
--ASC	--ASCENDING
;

SELECT
		[Преподаватель]		=	FORMATMESSAGE(N'%s %s %s', last_name, first_name,middle_name),
		[Дата рождения]		=	birth_date,
		[Возраст]			=	CAST(DATEDIFF(DAY, birth_date, GETDATE())/365.25 AS INT)
FROM	Teachers;