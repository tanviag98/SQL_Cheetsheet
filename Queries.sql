--Create/Alter/Drop a Database

create database sample1
--when database is created there are 2 files generated 
--1. .MDF Master data file(contains actual data)
--2. .LDF Log data file - Transition log file (used to recover the database)

-- Rename a database
Alter database sample1 modify name=sample2

--Drop a database

Drop database sample2
-- this will detelet both MDF and LDF datafile.

--You cannot drop a database, if it is currently in use. You get an error stating - Cannot drop database "NewDatabaseName" because it is currently in use. So, if other users are connected, you need to put the database in single user mode and then drop the database.

Alter Database DatabaseName Set SINGLE_USER With Rollback Immediate

--With Rollback Immediate option, will rollback all incomplete transactions and closes the connection to the database.


--create table with primary key constraint
use database sample2

CREATE TABLE tblPerson
(
    ID int not null,
    [Name] nvarchar(50) not null,
    Email nvarchar(50) not null,
    GenderId int
)

Create Table tblGender
(ID int Not Null Primary Key,
Gender nvarchar(50))

--to add a foreign key reference using a query
Alter table tblPerson 
add constraint tblPerson_GenderId_FK FOREIGN KEY (GenderId) references tblGender(ID)


--The general formula is here
Alter table ForeignKeyTable add constraint ForeignKeyTable_ForiegnKeyColumn_FK 
FOREIGN KEY (ForiegnKeyColumn) references PrimaryKeyTable (PrimaryKeyColumn)

--Adding Default constraint

Insert into tblPerson (ID,[Name],Email) values(1,'tanvi','tanviag98@gmail.com')

ALTER TABLE tblGender
ADD CONSTRAINT DF_tblGender_genderId
DEFAULT 3 GenderId

select round(avg(replacement_cost),2)
from film;

--Difference between having and where clause 
select company ,sum(sales) from finance_table
where company!='Google'
group by company;

-- Having clause will allow to use aggregate function to filter out the records after using group by
select company ,sum(sales) from finance_table
where company!='Google'
group by company
having sum(sales)>2000;


select customer_id,sum(amount) from public.payment
where staff_id =2
group by customer_id
having sum(amount) > 110 ;


select count(*) FROM public.film
where title ILIKE 'J%';

SELECT first_name, last_name from public.customer
where first_name ILIKE 'E%' and address_id <500
ORDER BY customer_id DESC
limit 1;

--Overview of JOINS
--FULL INNER JOIN / INNER JOIN

--OUTER JOIN
    --FULL OUTER JOIN / OUTER JOIN
    --LEFT OUTER JOIN / LEFT JOIN
    --RIGHT OUTER JOIN / RIGHT JOIN

select email,district from public.customer 
LEFT OUTER JOIN public.address
ON customer.address_id = address.address_id
WHERE district='California';

SELECT title,actor.first_name,actor.last_name  FROM public.film
INNER JOIN public.film_actor
on film.film_id = film_actor.film_id
INNER JOIN actor
on film_actor.actor_id=actor.actor_id
where film_actor.actor_id= (select actor_id from public.actor where first_name='Nick' and  last_name='Wahlberg')         


--UNION (rows of table1 + rows of table2)
select * from table1
UNION
select * from table2


--pgadmin commands
SHOW all;

SHOW TIMEZONE;
Asia/Kolkata


select NOW() --will give timezone with timestamp
2023-02-12 20:31:51.499595+05:30

SELECT TIMEOFDAY()
Sun Feb 12 20:31:26.334998 2023 IST

SELECT CURRENT_TIME
20:33:15.546242+05:30

SELECT CURRENT_DATE
2023-02-12

--Extract function (allows us to extract or obtain sub-component of the date value)

EXTRACT(YEAR FROM date_col)

--AGE function calculate the current age
AGE(date_col)

--TO_CHAR general function to convert datatype to text

TO_CHAR(date_col, 'mm-dd-yyyy')


select extract(YEAR from payment_date) as yearr
from public.payment;

select distinct(TO_CHAR(payment_date,'MONTH'))
FROM public.payment;


select TO_CHAR(payment_date,'DAY'),count(*)
from public.payment
group by TO_CHAR(payment_date,'DAY');

--------------------------------------

--- Command to see the list of databases
Show databases;

--- Command Create database
create database noob_db;

--- Command to delete database
drop database first_demo;

--- Command to get inside a database
use noob_db;

--- Command to create a table
CREATE TABLE if not EXISTS employee
(
	id INT,
    emp_name VARCHAR(20)
);

--- Command to see the list of tables
show tables;

--- Command to see the table definition
show create table employee;

--- Create employee table with few more columns
CREATE TABLE if not EXISTS employee_v1
(
	id INT,
    name VARCHAR(50),
    salary DOUBLE, 
    hiring_date DATE 
);

--- Syntax 1 to insert data into a table
insert into employee_v1 values(1,'Shashank',1000,'2021-09-15');

--- This statement will fail
insert into employee_v1 values(1,'Shashank','2021-09-15');

--- Syntax 2 to insert data into a table
insert into employee_v1(salary,name,id) 
values(2000,'Rahul',2);

--- Command to insert multiple records into a table
insert into employee_v1 values(3,'Amit',5000,'2021-10-28'),
(4,'Nitin',3500,'2021-09-16'),
(5,'Kajal',4000,'2021-09-20');
    
--- How to query or fetch the data from a table
select * from employee_v1;

--- Example table for integrity constraints
CREATE TABLE if not EXISTS employee_with_constraints
(
	id INT,
    name VARCHAR(50) NOT NULL,
    salary DOUBLE, 
    hiring_date DATE DEFAULT '2021-01-01',
    UNIQUE (id),
    CHECK (salary > 1000)
);

--- Example 1 for IC failure
--- Exception - Column 'name' cannot be null
insert into employee_with_constraints values(1,null,3000,'2021-11-20');

--- Correct record
insert into employee_with_constraints values(1,'Shashank',3000,'2021-11-20');

--- Example 2 for IC failure
--- Exception - Duplicate entry '1' for key 'employee_with_constraints.id'
insert into employee_with_constraints values(1,'Rahul',5000,'2021-10-23');

--- Another correct record because Unique can accept NULL as well
insert into employee_with_constraints 
values(null,'Rahul',5000,'2021-10-23');

--- Example 3 for IC failure
--- Exception - Duplicate entry NULL for key 'employee_with_constraints.id'
insert into employee_with_constraints 
values(null,'Rajat',2000,'2020-09-20');


--- Example 4 for IC failure
--- Exception - Check constraint 'employee_with_constraints_chk_1' is violated
insert into employee_with_constraints 
values(5,'Amit',500,'2023-10-24');

--- Test IC for default date
insert into employee_with_constraints(id,name,salary)
values(7,'Neeraj',3000);

select * from employee_with_constraints;

--- Example table for integrity constraints
CREATE TABLE if not EXISTS employee_with_constraints_tmp
(
	id INT,
    name VARCHAR(50) NOT NULL,
    salary DOUBLE, 
    hiring_date DATE DEFAULT '2021-01-01',
    Constraint unique_emp_id UNIQUE (id),
    Constraint salary_check CHECK (salary > 1000)
);

--- Check the name of constraint when it fails
--- Exception - Check constraint 'salary_check' is violated
insert into employee_with_constraints_tmp 
values(5,'Amit',500,'2023-10-24');



