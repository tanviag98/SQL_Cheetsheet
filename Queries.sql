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

