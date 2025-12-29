USE SPU_411_DDL;

--CREATE TABLE Disciplines
--(
--    discipline_id   SMALLINT      PRIMARY KEY,
--    discipline_name NVARCHAR(256) NOT NULL,
--    number_of_lessons TINYINT     NOT NULL
--);

--CREATE TABLE TeachersDisciplineRelation
--(
--    teacher    INT,     
--    discipline SMALLINT,
--    PRIMARY KEY (teacher, discipline),
--    CONSTRAINT FK_TDR_Teacher FOREIGN KEY (teacher) 
--        REFERENCES Teachers(teacher_id),
--    CONSTRAINT FK_TDR_Discipline FOREIGN KEY (discipline) 
--        REFERENCES Disciplines(discipline_id)
--);

--CREATE TABLE DisciplineDirectionRelation
--(
--    discipline SMALLINT,
--    direction  TINYINT,
--    PRIMARY KEY (discipline, direction),
--    CONSTRAINT FK_DDR_Discipline FOREIGN KEY (discipline) 
--        REFERENCES Disciplines(discipline_id),
--    CONSTRAINT FK_DDR_Direction FOREIGN KEY (direction) 
--        REFERENCES Directions(direction_id)
--);

--CREATE TABLE RequiredDisciplines
--(
--    discipline           SMALLINT,
--    required_discipline    SMALLINT,
--    PRIMARY KEY(discipline, required_discipline),
--    CONSTRAINT FK_RD_Discipline FOREIGN KEY (discipline)            REFERENCES Disciplines(discipline_id),
--    CONSTRAINT FK_RD_Requires FOREIGN KEY   (required_discipline)   REFERENCES Disciplines(discipline_id)
--);

CREATE TABLE DependentDisciplines
(
    discipline              SMALLINT,
    dependent_discipline   SMALLINT,
    PRIMARY KEY (discipline, dependent_discipline),
    CONSTRAINT FK_DD_Discipline FOREIGN KEY (discipline)  REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_DD_Dependent FOREIGN KEY (dependent_discipline)  REFERENCES Disciplines(discipline_id)
);