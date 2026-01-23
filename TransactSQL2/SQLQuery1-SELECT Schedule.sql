--SQLQuery1-SELECT Schedule.sql
USE SPU_411_Import;

SELECT 
			[Группа]		=	group_name,
			[Дисциплина]	=	discipline_id,
			[Преподаватель]	=	FORMATMESSAGE(N'%s %s %s', last_name,first_name,middle_name),
			[Дата]			=	[date],
			[Время]			=	[time],
			[Статус]		=	IIF(spent=1, N'Проведено', N'Запланировано')
FROM		Schedule
JOIN		Groups			ON	[group]		=	group_id
JOIN		Disciplines		ON	discipline	=	discipline_id
JOIN		Teachers		ON	teacher		=	teacher_id
WHERE		[group_name]	=	N'SPU 411'
ORDER	BY	[date]
;
