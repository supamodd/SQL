SELECT 
    stud_id,
    last_name,
    first_name,
    middle_name,
    birth_date,
    email,
    [group]
FROM Students
WHERE [group] = 777
ORDER BY last_name;