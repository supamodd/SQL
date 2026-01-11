--SQLQuery1-INSERT Groups.sql

USE SPU_411_DDL;

--INSERT Groups
--		(group_id, group_name, direction)
--VALUES
--		(1, N'PU_211', 1),
--		(2, N'PV_211', 1),
--		(3, N'PD_212', 1),
--		(4, N'PD_321', 1),
--		(5, N'PV_319', 1),
--		(6, N'SU_211', 2),
--		(7, N'SV_211', 2),
--		(8, N'DU_314', 3)
--;

SELECT
		group_id		AS	N'ID',
		group_name		AS	N'Название группы',
		direction_name	AS	N'Направление обучения'
FROM	Groups,Directions
WHERE	direction	=	direction_id;