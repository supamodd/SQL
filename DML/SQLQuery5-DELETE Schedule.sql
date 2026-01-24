--SQLQuery5-DELETE Schedule.sql
USE SPU_411_Import;

DELETE FROM Schedule WHERE [group]=411;
SELECT * FROM Schedule --WHERE [group]=411;