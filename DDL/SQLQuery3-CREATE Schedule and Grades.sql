USE SPU_411_DDL;

--CREATE TABLE Schedule
--(
--    lesson_id   BIGINT        PRIMARY KEY,
--    [date]      DATE          NOT NULL,
--    [time]      TIME(0)       NOT NULL, 
--    [group]     INT           NOT NULL,
--    discipline  SMALLINT      NOT NULL,
--    teacher     INT           NOT NULL,
--    spent       BIT           NOT NULL DEFAULT 0,
--    subject     NVARCHAR(255) NULL,
--    CONSTRAINT FK_Schedule_Group FOREIGN KEY ([group])  REFERENCES Groups(group_id),
--    CONSTRAINT FK_Schedule_Discipline FOREIGN KEY (discipline)  REFERENCES Disciplines(discipline_id),
--    CONSTRAINT FK_Schedule_Teacher FOREIGN KEY (teacher)   REFERENCES Teachers(teacher_id)
--);

--CREATE TABLE AttendanceAndGrades
--(
--student		INT,
--lesson		BIGINT,
--present		BIT NOT NULL,
--grade_1		TINYINT NULL,
--CONSTRAINT CK_Grade_1 CHECK (grade_1 > 0 AND grade_1 <= 12),
--grade_2 TINYINT NULL
--CONSTRAINT CK_Grade_2 CHECK (grade_2 > 0 AND grade_2 <= 12),
--PRIMARY KEY(student, lesson)
--);

--CREATE TABLE Exams
--(
-- student	INT,
-- discipline SMALLINT,
-- grade		TINYINT
-- CONSTRAINT CK_Grade	CHECK	(grade > 0 AND grade <=12),
-- PRIMARY KEY(student, discipline)
--);

ALTER TABLE AttendanceAndGrades
ADD 
CONSTRAINT FK_Grades_Students FOREIGN KEY(student)		REFERENCES Students(student_id),
CONSTRAINT FK_Grades_Schedule FOREIGN KEY(lesson)		REFERENCES Schedule(lesson_id)

ALTER TABLE Exams
ADD
CONSTRAINT FK_Exams_Students	FOREIGN KEY(student)		REFERENCES Students(student_id),
CONSTRAINT FK_Exams_Discipline	FOREIGN KEY(discipline)		REFERENCES Disciplines(discipline_id)