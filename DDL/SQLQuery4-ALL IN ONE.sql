USE SPU_411_ALL;

CREATE DATABASE SPU_411_ALL
ON
(
	NAME	= SPU_411_DDL,
	FILENAME= 'D:\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Data\SPU_411_ALL.mdf',
	SIZE	= 8 MB,
	MAXSIZE	= 500 MB,
	FILEGROWTH	= 8 MB
)
LOG ON
(
	NAME	= SPU_411_Log,
	FILENAME	= 'D:\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Data\SPU_411_ALL.ldf',
	SIZE	= 8 MB,
	MAXSIZE	= 500 MB,
	FILEGROWTH = 5 MB
)

--DROP TABLE Directions;

CREATE TABLE Directions
(
	direction_id TINYINT PRIMARY KEY,
	direction_name NVARCHAR(150) NOT NULL
)

CREATE TABLE Groups
(
	group_id	INT		PRIMARY KEY,
	group_name	NVARCHAR(24)	NOT NULL,
	direction	TINYINT			NOT NULL
	CONSTRAINT FK_Group_Direction FOREIGN KEY REFERENCES Directions(direction_id)
);

CREATE TABLE Students
(
    student_id  INT           PRIMARY KEY,
    last_name   NVARCHAR(50)  NOT NULL,
    first_name  NVARCHAR(50)  NOT NULL,
    middle_name NVARCHAR(50)  NULL,
    birth_date  DATE          NOT NULL,
    [group]     INT           NOT NULL,
    CONSTRAINT FK_Students_Groups FOREIGN KEY ([group]) 
        REFERENCES Groups(group_id)
);

CREATE TABLE Teachers
(
    teacher_id  INT           PRIMARY KEY,
    last_name   NVARCHAR(50)  NOT NULL,
    first_name  NVARCHAR(50)  NOT NULL,
    middle_name NVARCHAR(50),
    birth_date  DATE          NULL,
    rate        MONEY         NULL
);

CREATE TABLE Disciplines
(
    discipline_id   SMALLINT      PRIMARY KEY,
    discipline_name NVARCHAR(256) NOT NULL,
    number_of_lessons TINYINT     NOT NULL
);

CREATE TABLE TeachersDisciplineRelation
(
    teacher    INT,     
    discipline SMALLINT,
    PRIMARY KEY (teacher, discipline),
    CONSTRAINT FK_TDR_Teacher FOREIGN KEY (teacher) 
        REFERENCES Teachers(teacher_id),
    CONSTRAINT FK_TDR_Discipline FOREIGN KEY (discipline) 
        REFERENCES Disciplines(discipline_id)
);

CREATE TABLE DisciplineDirectionRelation
(
    discipline SMALLINT,
    direction  TINYINT,
    PRIMARY KEY (discipline, direction),
    CONSTRAINT FK_DDR_Discipline FOREIGN KEY (discipline) 
        REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_DDR_Direction FOREIGN KEY (direction) 
        REFERENCES Directions(direction_id)
);

CREATE TABLE RequiredDisciplines
(
    discipline           SMALLINT,
    required_discipline    SMALLINT,
    PRIMARY KEY(discipline, required_discipline),
    CONSTRAINT FK_RD_Discipline FOREIGN KEY (discipline)            REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_RD_Requires FOREIGN KEY   (required_discipline)   REFERENCES Disciplines(discipline_id)
);

CREATE TABLE DependentDisciplines
(
    discipline              SMALLINT,
    dependent_discipline   SMALLINT,
    PRIMARY KEY (discipline, dependent_discipline),
    CONSTRAINT FK_DD_Discipline FOREIGN KEY (discipline)  REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_DD_Dependent FOREIGN KEY (dependent_discipline)  REFERENCES Disciplines(discipline_id)
);

CREATE TABLE Schedule
(
    lesson_id   BIGINT        PRIMARY KEY,
    [date]      DATE          NOT NULL,
    [time]      TIME(0)       NOT NULL, 
    [group]     INT           NOT NULL,
    discipline  SMALLINT      NOT NULL,
    teacher     INT           NOT NULL,
    spent       BIT           NOT NULL DEFAULT 0,
    subject     NVARCHAR(255) NULL,
    CONSTRAINT FK_Schedule_Group FOREIGN KEY ([group])  REFERENCES Groups(group_id),
    CONSTRAINT FK_Schedule_Discipline FOREIGN KEY (discipline)  REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_Schedule_Teacher FOREIGN KEY (teacher)   REFERENCES Teachers(teacher_id)
);

CREATE TABLE AttendanceAndGrades
(
student		INT,
lesson		BIGINT,
present		BIT NOT NULL,
grade_1		TINYINT NULL,
CONSTRAINT CK_Grade_1 CHECK (grade_1 > 0 AND grade_1 <= 12),
grade_2 TINYINT NULL
CONSTRAINT CK_Grade_2 CHECK (grade_2 > 0 AND grade_2 <= 12),
PRIMARY KEY(student, lesson)
);

CREATE TABLE Exams
(
 student	INT,
 discipline SMALLINT,
 grade		TINYINT
 CONSTRAINT CK_Grade	CHECK	(grade > 0 AND grade <=12),
 PRIMARY KEY(student, discipline)
);

ALTER TABLE AttendanceAndGrades
ADD 
CONSTRAINT FK_Grades_Students FOREIGN KEY(student)		REFERENCES Students(student_id),
CONSTRAINT FK_Grades_Schedule FOREIGN KEY(lesson)		REFERENCES Schedule(lesson_id)

ALTER TABLE Exams
ADD
CONSTRAINT FK_Exams_Students	FOREIGN KEY(student)		REFERENCES Students(student_id),
CONSTRAINT FK_Exams_Discipline	FOREIGN KEY(discipline)		REFERENCES Disciplines(discipline_id)