--SQLQuery5-SELECT Schedule.sql
USE SPU_411_Import;

SELECT
		[Группа]		=		group_name,
		[Дата]			=		[date],
		[Время]			=		[time],
		[Дисциплина]	=		discipline_name,
		[Преподаватель] =		FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name)
FROM	Schedule
JOIN	Groups			ON		([group]=group_id)
JOIN	Disciplines		ON		discipline=discipline_id
JOIN	Teachers		ON		teacher=teacher_id
WHERE	group_name		=		N'SPU_411'
ORDER BY [date]
;

SELECT COUNT([group]) FROM Schedule JOIN Groups ON [group] = group_id WHERE group_name = N'SPU_411';