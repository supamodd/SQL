USE SPU_411_DDL;

CREATE TABLE Teachers
(
    teacher_id  INT           PRIMARY KEY,
    last_name   NVARCHAR(50)  NOT NULL,
    first_name  NVARCHAR(50)  NOT NULL,
    middle_name NVARCHAR(50),
    birth_date  DATE          NULL,
    rate        MONEY         NULL
);