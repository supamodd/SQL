--SQLQuery1-CREATE Students Branch.sql
USE SPU_411_DDL;

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
    birth_date  DATE          NULL,
    [group]     INT           NOT NULL,
    CONSTRAINT FK_Students_Groups FOREIGN KEY ([group]) 
        REFERENCES Groups(group_id)
);


CREATE TABLE Disciplines
(
    discipline_id   SMALLINT      PRIMARY KEY,
    discipline_name NVARCHAR(150) NOT NULL
);


CREATE TABLE DisciplineDirectionRelation
(
    discipline_id SMALLINT NOT NULL,
    direction_id  TINYINT  NOT NULL,
    PRIMARY KEY (discipline_id, direction_id),
    CONSTRAINT FK_DDR_Discipline FOREIGN KEY (discipline_id) 
        REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_DDR_Direction FOREIGN KEY (direction_id) 
        REFERENCES Directions(direction_id)
);


CREATE TABLE RequiredDisciplines
(
    required_discipl_id SMALLINT PRIMARY KEY,
    required_discipl    SMALLINT NOT NULL,
    CONSTRAINT FK_RequiredDisciplines_Discipline FOREIGN KEY (required_discipl) 
        REFERENCES Disciplines(discipline_id)
);


CREATE TABLE DependentDisciplines
(
    discipline_id       SMALLINT NOT NULL,
    dependent_discipl   SMALLINT NOT NULL,
    PRIMARY KEY (discipline_id, dependent_discipl),
    CONSTRAINT FK_DD_Discipline FOREIGN KEY (discipline_id) 
        REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_DD_Dependent FOREIGN KEY (dependent_discipl) 
        REFERENCES Disciplines(discipline_id)
);


CREATE TABLE Teachers
(
    teacher_id  INT           PRIMARY KEY,
    last_name   NVARCHAR(50)  NOT NULL,
    first_name  NVARCHAR(50)  NOT NULL,
    middle_name NVARCHAR(50)  NULL,
    birth_date  DATE          NULL
);


CREATE TABLE TeachersDisciplineRelation
(
    teacher_id    INT      NOT NULL,
    discipline_id SMALLINT NOT NULL,
    PRIMARY KEY (teacher_id, discipline_id),
    CONSTRAINT FK_TDR_Teacher FOREIGN KEY (teacher_id) 
        REFERENCES Teachers(teacher_id),
    CONSTRAINT FK_TDR_Discipline FOREIGN KEY (discipline_id) 
        REFERENCES Disciplines(discipline_id)
);


CREATE TABLE Schedule
(
    lesson_id   BIGINT        PRIMARY KEY,
    [date]      DATE          NOT NULL,
    time        TIME(0)       NOT NULL,  
    [group]     INT           NOT NULL,
    discipline  SMALLINT      NOT NULL,
    teacher     INT           NOT NULL,
    spent       BIT           NOT NULL DEFAULT 0,
    subject     NVARCHAR(255) NULL,
    CONSTRAINT FK_Schedule_Groups FOREIGN KEY ([group]) 
        REFERENCES Groups(group_id),
    CONSTRAINT FK_Schedule_Discipline FOREIGN KEY (discipline) 
        REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_Schedule_Teacher FOREIGN KEY (teacher) 
        REFERENCES Teachers(teacher_id)
);


CREATE TABLE Attendance
(
    attendance_id INT      PRIMARY KEY,
    student       INT      NOT NULL,
    discipline    SMALLINT NOT NULL,
    is_present    BIT      NOT NULL,
    reason        VARCHAR(255) NULL,
    CONSTRAINT FK_Attendance_Student FOREIGN KEY (student) 
        REFERENCES Students(student_id),
    CONSTRAINT FK_Attendance_Discipline FOREIGN KEY (discipline) 
        REFERENCES Disciplines(discipline_id)
);


CREATE TABLE Grades
(
    grade_id    INT      PRIMARY KEY,
    student     INT      NOT NULL,
    discipline  SMALLINT NOT NULL,
    exam_id     INT      NULL,      
    grade       TINYINT  NOT NULL,
    grade_date  DATE     NOT NULL,
    comment     VARCHAR(255) NULL,
    CONSTRAINT FK_Grades_Student FOREIGN KEY (student) 
        REFERENCES Students(student_id),
    CONSTRAINT FK_Grades_Discipline FOREIGN KEY (discipline) 
        REFERENCES Disciplines(discipline_id)
);


CREATE TABLE Exams
(
    exam_id     INT           PRIMARY KEY,
    discipline  SMALLINT      NOT NULL,
    teacher     INT           NOT NULL,
    [group]     INT           NOT NULL,
    exam_name   NVARCHAR(150) NULL,
    exam_date   DATE          NOT NULL,
    exam_type   VARCHAR(50)   NULL,
    max_score   TINYINT       NULL,
    CONSTRAINT FK_Exams_Discipline FOREIGN KEY (discipline) 
        REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_Exams_Teacher FOREIGN KEY (teacher) 
        REFERENCES Teachers(teacher_id),
    CONSTRAINT FK_Exams_Groups FOREIGN KEY ([group]) 
        REFERENCES Groups(group_id)
);


CREATE TABLE Rates
(
    rate_id       INT          PRIMARY KEY,
    rate_category NVARCHAR(50) NOT NULL,
    bonus         DECIMAL(5,2) NULL,
    effective_fr  DATE         NULL,
    effective_to  DATE         NULL,
    comment       VARCHAR(255) NULL
);