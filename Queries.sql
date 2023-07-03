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

--------------------------------------------

Create database class2_db;

use class2_db;

create table if not exists employee(
    id int,
    name VARCHAR(50),
    address VARCHAR(50),
    city VARCHAR(50)
);

insert into employee values(1, 'Shashank', 'RJPM', 'Lucknow');

select * from employee;

--- add new column named DOB in the TABLE
alter table employee add DOB date;

select * from employee;


--- modify existing column in a TABLE or change datatype of name column or increase lenght of name column
alter table employee modify column name varchar(100);

--- delete existing column from given TABLE or remove city column from employee table
alter table employee drop column city;

select * from employee;


--- rename the column name to full_name
alter table employee rename column name to full_name;


create table if not exists employee(
    id int,
    name VARCHAR(50),
    age int,
    hiring_date date,
    salary int,
    city varchar(50)
);

insert into employee values(1,'Shashank', 24, '2021-08-10', 10000, 'Lucknow');

insert into employee values(2,'Rahul', 25, '2021-08-10', 20000, 'Khajuraho');

insert into employee values(3,'Sunny', 22, '2021-08-11', 11000, 'Banaglore');

insert into employee values(5,'Amit', 25, '2021-08-11', 12000, 'Noida');

insert into employee values(6,'Puneet', 26, '2021-08-12', 50000, 'Gurgaon');

--- add unique integrity constraint on id COLUMN

alter table employee add constraint id_unique UNIQUE(id);

insert into employee values(1,'XYZ', 25, '2021-08-10', 50000, 'Gurgaon');

--- drop constraint from existing TABLE
alter table employee drop constraint id_unique;

insert into employee values(1,'XYZ', 25, '2021-08-10', 50000, 'Gurgaon');

--- create table with Primary_Key

Create table persons
(
    id int, 
    name varchar(50), 
    age int,
    ---Primary Key (id) 
    constraint pk Primary Key (id) 
);

insert into persons values(1,'Shashank',29);

--- Try to insert duplicate value for primary key COLUMN
insert into persons values(1,'Rahul',28);

--- Try to insert null value for primary key COLUMN
insert into persons values(null,'Rahul',28);

--- To check difference between Primary Key and Unique
alter table persons add constraint age_unq UNIQUE(age); 

select * from persons;


insert into persons values(2,'Rahul',28);


insert into persons values(3,'Amit',28);

insert into persons values(3,'Amit',null);

select * from persons;

insert into persons values(4,'Charan',null);

insert into persons values(5,'Deepak',null);


--- create tables for Foreign Key demo
create table customer
(
    cust_id int,
    name VARCHAR(50), 
    age int,
    constraint pk Primary Key (cust_id) 
);

create table orders
(
    order_id int,
    order_num int,
    customer_id int,
    constraint pk Primary Key (order_id),
    constraint fk Foreign Key (customer_id) REFERENCES customer(cust_id)
);

--- Differen between Drop & Truncate Command

select * from persons;
truncate table persons;

select * from persons;

drop table persons;

--- Operations with Select Command

select * from employee;


drop table employee;


create table if not exists employee(
    id int,
    name VARCHAR(50),
    age int,
    hiring_date date,
    salary int,
    city varchar(50)
);

insert into employee values(1,'Shashank', 24, '2021-08-10', 10000, 'Lucknow');

insert into employee values(2,'Rahul', 25, '2021-08-10', 20000, 'Khajuraho');

insert into employee values(3,'Sunny', 22, '2021-08-11', 11000, 'Bangalore');

insert into employee values(5,'Amit', 25, '2021-08-11', 12000, 'Noida');

insert into employee values(1,'Puneet', 26, '2021-08-12', 50000, 'Gurgaon');


select * from employee;

--- how to count total records
select count(*) from employee;


--- alias declaration
select count(*) as total_row_count from employee;


--- display all columns in the final result
select * from employee;


--- display specific columns in the final result
select name, salary from employee;


--- aliases for mutiple columns
select name as employee_name, salary as employee_salary from employee;


select * from employee;

--- print unique hiring_dates from the employee table when employees joined it
select Distinct(hiring_date) as distinct_hiring_dates from employee;


select * from employee;

--- How many unique age values in the table??

select  count(distinct(age)) as total_unique_ages from employee;

--- Increment salary of each employee by 20% and display final result with new salary
SELECT  id,
        name,
        salary as old_salary, 
        (salary + salary * 0.2) as new_salary
FROM employee;


-- Syntax for update command
select * from employee;

--- Upadtes will be made for all rows
UPDATE employee SET age = 20;

select * from employee;

--- update the salary of employee after giving 20% increment
UPDATE employee SET salary = salary + salary * 0.2;

select * from employee;


--- How to filter data using WHERE Clauses
select * from employee where hiring_date = '2021-08-10';


select * from employee;

--- Update the salary of employees who joined the company on 2021-08-10 to 80000
update employee SET salary = 80000 where hiring_date = '2021-08-10';

select * from employee;


--- how to delete specific records from table using delete command
--- delete records of those employess who joined company on 2021-08-10

delete from employee where hiring_date = '2021-08-10';


select * from employee;

--- How to apply auto increment
create table auto_inc_exmp
(
  id int auto_increment,
  name varchar(20),
  primary key (id)
);

insert into auto_inc_exmp(name) values('Shashank');
insert into auto_inc_exmp(name) values('Rahul');

select * from auto_inc_exmp;

--- Use of limit 
select * from employee;
select * from employee limit 2;


# sorting data in mysql by using 'Order By'
select * from employee;

# arrage data in ascending order
select * from employee order by name;


# arrage data in descending order
select * from employee order by name desc;

# display employee data in desc order of salary and if salaries are same for more than one employees
# arrange their data in ascedinding order of name

select * from employee order by salary desc, name asc;

# when we ignore multilevel ordering
select * from employee order by salary desc;

# Write a query to find the employee who is getting maximum salary?
select * from employee order by salary desc limit 1;


# Write a query to find the employee who is getting minium salary?
select * from employee order by salary limit 1;


# Write a query to find the employee who is getting minium salary?
select * from employee order by salary limit 1;

# Conditional Operators ->    < , > , <= , >= 
# Logical Operator -> AND, OR, NOT

select * from employee;

# list all employees who are getting salary more than 20000
select * from employee where salary>20000;

# list all employees who are getting salary more than or equal to 20000
select * from employee where salary>=20000;

# list all employees who are getting less than 20000
select * from employee where salary<20000;

# list all employees who are getting salary less than or equal to 20000
select * from employee where salary<=20000;


# filter the record where age of employees is equal to 20
select * from employee where age=20;

# filter the record where age of employees is not equal to 20
# we can use != or we can use <>
select * from employee where age != 20;
select * from employee where age <> 20;

# find those employees who joined the company on 2021-08-11 and their salary is less than 11500
select * from employee where hiring_date = '2021-08-11' and salary<11500;

# find those employees who joined the company after 2021-08-11 or  their salary is less than 20000
select * from employee where hiring_date > '2021-08-11' or salary<20000;

# how to use Between operation in where clause
# get all employees data who joined the company between hiring_date 2021-08-05 to 2021-08-11
select * from employee where hiring_date between '2021-08-05' and '2021-08-11';

# get all employees data who are getting salary in the range of 10000 to 28000
select * from employee where salary between 10000 and 28000;

# how to use LIKE operation in where clause
# % -> Zero, one or more than one characters
# _ -> only one character

# get all those employees whose name starts with 'S'
select * from employee where name like 'S%';

# get all those employees whose name starts with 'Sh'
select * from employee where name like 'Sh%';

# get all those employees whose name ends with 'l'
select * from employee where name like '%l';

# get all those employees whose name starts with 'S' and ends with 'k'
select * from employee where name like 'S%k';

# Get all those employees whose name will have exact 5 characters
select * from employee where name like '_____';

# Return all those employees whose name contains atleast 5 characters
select * from employee where name like '%_____%';

# How to use IS NULL or IS NOT NULL in the where clause
insert into employee values(10,'Kapil', null, '2021-08-10', 10000, 'Assam');
insert into employee values(11,'Nikhil', 30, '2021-08-10', null, 'Assam');

select * from employee;

# get all those employees whos age value is null
select * from employee where age is null;

select * from employee;

# get all those employees whos salary value is not null
select * from employee where salary is not null;


# Table and Data for Group By
create table orders_data
(
 cust_id int,
 order_id int,
 country varchar(50),
 state varchar(50)
);


insert into orders_data values(1,100,'USA','Seattle');
insert into orders_data values(2,101,'INDIA','UP');
insert into orders_data values(2,103,'INDIA','Bihar');
insert into orders_data values(4,108,'USA','WDC');
insert into orders_data values(5,109,'UK','London');
insert into orders_data values(4,110,'USA','WDC');
insert into orders_data values(3,120,'INDIA','AP');
insert into orders_data values(2,121,'INDIA','Goa');
insert into orders_data values(1,131,'USA','Seattle');
insert into orders_data values(6,142,'USA','Seattle');
insert into orders_data values(7,150,'USA','Seattle');

select * from orders_data;

# calculate total order placed country wise
select country, count(*) as order_count_by_each_country from orders_data group by country;

# Write a query to find the total salary by each age group 
select * from employee;
select age, sum(salary) as total_salary_by_each_age_group from employee group by age;

# calculate different aggregated metrices for salary
select age, 
	   sum(salary) as total_salary_by_each_age_group,
       max(salary) as max_salary_by_each_age_group,
       min(salary) as min_salary_by_each_age_group,
       avg(salary) as avg_salary_by_each_age_group,
       count(*) as total_employees_by_each_age_group
from employee group by age;

# Use of Having Clause
# Write a query to find the country where only 1 order was placed
select country from orders_data group by country having count(*)=1;

# Where Clause and Group By Clause --> What should be the proper sequence??
# Answer -> Where Clause and then Group By ??

# How to use GROUP_CONCAT
# Query - Write a query to print distinct states present in the dataset for each country?
select country, GROUP_CONCAT(state) as states_in_country from orders_data group by country;

select country, GROUP_CONCAT(distinct state) as states_in_country from orders_data group by country;

select country, GROUP_CONCAT(distinct state order by state desc) as states_in_country from orders_data group by country;

select country, GROUP_CONCAT(distinct state order by state desc separator '<->') as states_in_country from orders_data group by country;

# Subqueries in SQL
create table employees
(
    id int,
    name varchar(50),
    salary int
);

insert into employees values(1,'Shashank',5000),(2,'Amit',5500),(3,'Rahul',7000),(4,'Rohit',6000),(5,'Nitin',4000),(6,'Sunny',7500);

select * from employees;

# Write a query to print all those employee records who are getting more salary than 'Rohit'

# Wrong solution -> select * from employees where salary > 6000; 
select * from employees where salary > (select salary from employees where name='Rohit');

# Use of IN and NOT IN
# Write a query to print all orders which were placed in 'Seattle' or 'Goa'
select * from orders_data;

SELECT * FROM orders_data WHERE state in ('Seattle', 'Goa');

create table customer_order_data
(
    order_id int,
    cust_id int,
    supplier_id int,
    cust_country varchar(50)
);


insert into customer_order_data values(101,200,300,'USA'),(102,201,301,'INDIA'),(103,202,302,'USA'),(104,203,303,'UK');

create table supplier_data
(
    supplier_id int,
    sup_country varchar(50)
);

insert into supplier_data values(300,'USA'),(303,'UK');

# write a query to find all customer order data where all coustomers are from same countries 
# as the suppliers
select * from customer_order_data where cust_country in 
(select distinct sup_country from supplier_data);

# Uber SQL Interview questions
create table tree
(
    node int,
    parent int
);

insert into tree values (5,8),(9,8),(4,5),(2,9),(1,5),(3,9),(8,null);

select * from tree;

select node,
       CASE
            when node not in (select distinct parent from tree where parent is not null) then 'LEAF'
            when parent is null then 'ROOT'
            else 'INNER'
       END as node_type
from tree;

# Examples for join
create table orders
(
    order_id int,
    cust_id int,
    order_dat date, 
    shipper_id int
);

create table customers
(
    cust_id int,
    cust_name varchar(50),
    country varchar(50)
);

create table shippers
(
    ship_id int,
    shipper_name varchar(50)
);

insert into orders values(10308, 2, '2022-09-15', 3);
insert into orders values(10309, 30, '2022-09-16', 1);
insert into orders values(10310, 41, '2022-09-19', 2);

insert into customers values(1, 'Neel', 'India');
insert into customers values(2, 'Nitin', 'USA');
insert into customers values(3, 'Mukesh', 'UK');

insert into shippers values(3,'abc');
insert into shippers values(1,'xyz');

select * from orders;
select * from customers;
select * from shippers;

# perform inner JOIN
# get the customer informations for each order order, if value of customer is present in orders TABLE
select 
o.*, c.*
from orders o
inner join customers c on o.cust_id = c.cust_id;

# Left Join
select 
o.*, c.*
from orders o
left join customers c on o.cust_id = c.cust_id;

# Right Join
select 
o.*, c.*
from orders o
right join customers c on o.cust_id = c.cust_id;


# Cross Join
-- select 
-- o.*, c.*
-- from orders o
-- full outer join customers c;

# How to join more than 2 datasets?
# perform inner JOIN
# get the customer informations for each order order, if value of customer is present in orders TABLE
# also get the information of shipper name
select 
o.*, c.*, s.*
from orders o
inner join customers c on o.cust_id = c.cust_id
inner join shippers s on o.shipper_id = s.ship_id;

create table employees_full_data
(
    emp_id int,
    name varchar(50),
    mgr_id int
);

insert into employees_full_data values(1, 'Shashank', 3);
insert into employees_full_data values(2, 'Amit', 3);
insert into employees_full_data values(3, 'Rajesh', 4);
insert into employees_full_data values(4, 'Ankit', 6);
insert into employees_full_data values(6, 'Nikhil', null);

select * from employees_full_data;

# Write a query to print the distinct names of managers??
select
emp.name as manager
from employees_full_data emp
inner join (select distinct mgr_id as mgr_id from employees_full_data) mgr on mgr.mgr_id = emp.emp_id;

