SELECT distinct first_name,
 last_name,
 age,
 age + 10
FROM parks_and_recreation.employee_demographics;

-- where statement
select *
from parks_and_recreation.employee_demographics
where gender = 'female' or NOT birth_date > '1989-01-01';

-- like statement
select *
from parks_and_recreation.employee_demographicsemployee_salaryemployee_salary
where first_name LIKE 'a__%' or birth_date like '1985%';



-- group by

select gender, avg(age), MAX(age), min(age), count(age)
from parks_and_recreation.employee_demographics
group by gender;

select occupation, salary
from parks_and_recreation.employee_salary
group by occupation, salary;


-- oder by statement
select *
from parks_and_recreation.employee_demographics
order by gender, age;


select occupation, avg(salary)
from parks_and_recreation.employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary)>70000;

select gender, avg(age) as avg_age
from parks_and_recreation.employee_demographics
group by gender;

select *from parks_and_recreation.employee_demographics
limit 3;



-- Join statement
select dem.employee_id, dem.first_name, age, occupation, salary
from parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id
    ;
    
    
-- left, right join
select *
from parks_and_recreation.employee_demographics as dem  -- left table
right join parks_and_recreation.employee_salary as sal -- righ table
	on dem.employee_id = sal.employee_id
    ;
    
-- self join

select * from
parks_and_recreation.employee_salary emp1
join parks_and_recreation.employee_salary emp2
	on emp1.employee_id= emp2.employee_id;
    

-- joining multiple tables togather
select *
from parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
	on dem.employee_id= sal.employee_id
inner join parks_and_recreation.parks_departments as pd
	on sal.dept_id = pd.department_id
    
    ;


-- unioin  statement 
select first_name, last_name
from parks_and_recreation.employee_demographics
union -- distinct that removes duplicates
select first_name, last_name
from parks_and_recreation.employee_salary;


select first_name, last_name, 'Old Man' as Label
from parks_and_recreation.employee_demographics 
where age>40 and gender ="Male"
union
select first_name, last_name, 'Old Woman' as Label
from parks_and_recreation.employee_demographics 
where age>40 and gender="Female"
union
select first_name, last_name, 'High Salary' as Label
from parks_and_recreation.employee_salary
where salary> 70000
order by first_name
;


-- length
-- upper lower
-- trim
-- substring
-- replace
-- locate
-- concatenation

select first_name, last_name,
concat(first_name, ' ', last_name) as FuLL_NAME
from parks_and_recreation.employee_demographics;

-- case statement
select first_name, last_name, age,
case 
	when age<=30 then 'Young'
    when age between 30 and 50 then "Old"
    when age>=50 then "Retired"
end as age_declaration
from parks_and_recreation.employee_demographics;

-- pay bonus scenorio
-- < 50000 = 5%
-- >50000 = 7%
-- finance = 10% bonus

select first_name, last_name, salary,
case
	when salary < 50000 then 1.05*salary
    when salary >= 50000 then 1.07*salary
end as bonus_salary,
case
	when dept_id = 6 then salary*0.1
end as especial_bonus
from parks_and_recreation.employee_salary;

select * from parks_and_recreation.employee_salary;

-- subqueries 
select * from parks_and_recreation.employee_demographics
where employee_id in(
					select employee_id 
                    from parks_and_recreation.employee_salary
                    where dept_id=1)
;
-- the same but very long
select dem.employee_id, dem.first_name, dem.last_name, dem.gender from parks_and_recreation.employee_demographics as dem
inner join parks_and_recreation.employee_salary as sal
on dem.employee_id=sal.employee_id
where dept_id=1;

-- subquery
select first_name, last_name, salary,
(select avg(salary) from parks_and_recreation.employee_salary)
from parks_and_recreation.employee_salary as sal
;

-- group by
select gender, avg(salary) as avg_salary
from parks_and_recreation.employee_demographics as dem
join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id
group by gender;

-- window functions 
SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender) AS avg_salary
FROM parks_and_recreation.employee_demographics AS dem
JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;

-- Rolling Total BY window function.
SELECT dem.first_name, dem.last_name, gender, salary, SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM parks_and_recreation.employee_demographics AS dem
JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;
    
 -- Row Number   
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS Row_Num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS RANKING,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS DENSE_RANKING
FROM parks_and_recreation.employee_demographics AS dem
JOIN parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;
    
    
    -- Advance SQL
	-- Common Table Expressions (CTE)
		-- the same as a subqueries but with a name
        -- Better than subqueries.
	
WITH CTE_Example As (
SELECT gender, AVG(salary) AS avg_sal
FROM employee_demographics AS dem JOIN employee_salary AS sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender 
)
SELECT AVG(avg_sal) FROM CTE_Example ;

-- with subquery
SELECT AVG(avg_sal) AS Avg_sal
FROM(
SELECT gender, AVG(salary) AS avg_sal
FROM employee_demographics AS dem JOIN employee_salary AS sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender 
) AS Example_with_subquery
;

-- Multiple Queries with CTE

WITH CTE_Example AS
(SELECT employee_id, first_name, last_name, gender
FROM employee_demographics AS dem
),
CTE_Example2 AS(
SELECT sal.employee_id, salary
FROM employee_salary AS sal)

SELECT *FROM CTE_Example
JOIN CTE_Example2 
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;
-- Alternative 
SELECT dem.employee_id, dem.first_name, dem.last_name, dem.gender, salary FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id;

-- Naming Columns 
WITH CTE_Example(Gender, Avg_Salary) -- Overwrite the Namings inside the query
AS (
SELECT gender, AVG(salary) AS avg_sal
FROM employee_demographics AS dem JOIN employee_salary AS sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender 
)
SELECT AVG(Avg_Salary) FROM CTE_Example ;


-- Temp Table
-- Traditional Way
CREATE TEMPORARY TABLE temp_table(
first_name VARCHAR(50),
last_name VARCHAR(50),
faculty VARCHAR(100),
address VARCHAR(150)
)
;

INSERT temp_table VALUES(
'Abdul Rauf', 'Mirzayee', 'Computer Science', 'Mofid Square Andasha Dormitory');
SELECT *FROM temp_table;

-- More Advanced VERSION 
CREATE TEMPORARY TABLE over_paid_employees
SELECT *FROM employee_salary WHERE salary>50000;
SELECT *FROM over_paid_employees;

CREATE TEMPORARY TABLE IF NOT EXISTS city_manager
SELECT *FROM employee_salary WHERE occupation="City Manager";
SELECT *FROM city_manager;


-- Store Procedures 
use parks_and_recreation;
CREATE PROCEDURE high_salary()
SELECT *FROM employee_salary 
WHERE salary >= 50000;

CALL high_salary();

-- multiple Queries in a Procedure
USE parks_and_recreation;
DROP PROCEDURE IF EXISTS new_procedure;
DELIMITER $$
CREATE PROCEDURE new_procedure()
BEGIN
	SELECT *FROM employee_salary
    WHERE salary >= 50000;
    SELECT *FROM employee_salary
    WHERE salary >10000;
END$$
DELIMITER ;

CALL new_procedure();
DROP PROCEDURE `parks_and_recreation`.`search`;

-- Passing Parameter

DELIMITER $$
CREATE PROCEDURE search(employee_id_para INT)
BEGIN
	SELECT *FROM employee_salary 
    WHERE employee_id = employee_id_para;
END$$
DELIMITER ;

CALL search(5);

-- TRIGGER
drop trigger if exists employee_insert;
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
		FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name) 
    VALUES(NEW.employee_id, NEW.first_name, NEW.last_name);

END $$
DELIMITER ;

INSERT INTO employee_salary(employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Abdul Rauf', 'Mirzayee', 'Entertainment', 60000, NULL);

SELECT *FROM employee_salary;
SELECT *FROM employee_demographics;

-- EVENT
DROP EVENT IF EXISTS remove_retired_emp;
DELIMITER $$
CREATE EVENT remove_retired_emp
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE FROM employee_demographics
    WHERE age > 60;
END $$
DELIMITER ;

SELECT *FROM employee_demographics;