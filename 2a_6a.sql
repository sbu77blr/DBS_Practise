
-- 300125
-- 2a) & 6a) : Employee DB

-- Creating tables.
CREATE TABLE IF NOT EXISTS Employee(
	Fname varchar(10),
	Lname varchar(10),
	SSN int primary key,
	Addr varchar(10),
	Sex varchar(1),
	salary float,
	SuperSSN int, 
	Dno int
);

CREATE TABLE IF NOT EXISTS Department(
	Dname varchar(15),
	Dnumber int primary key,
	MgrSSN int,
	MgrStartDate date
);

CREATE TABLE IF NOT EXISTS Project(
	Pno int primary key,
	Pname varchar(15),
	Dnum int
);

CREATE TABLE IF NOT EXISTS Works_On(
	ESSN int,
	Pno int,
	hours float
);

-- Adding the initial data.
insert into Employee values
('Sj', 'S', 100, 'Bjr', 'M', 60000, null, 1),
('V', 'K', 200, 'Blr', 'F', 60000, null, 2),
('Sh', 'K', 300, 'Clr', 'F', 60000, null, 3),
('S', 'E', 400, 'Cig', 'M', 45000, null, 4),
('Sn', 'B', 500, 'Mys', 'M', 25000, null, 5);

insert into Department values
('Administration', 1, 100, '2024-10-01'),
('Finance', 2, 200, '2024-10-01'),
('CyberSecurity', 3, 300, '2024-10-01'),
('Bcknd-Mgmt', 4, 400, '2024-10-01'),
('Mgmt', 5, 500, '2024-10-01');


--Setting the foreign keys.

alter table Employee ADD constraint FK_Dno foreign key(Dno) references Department(Dnumber) on update cascade on delete set null,
	ADD constraint FK_SuperSSN foreign key(SuperSSN) references Employee(SSN) on update cascade on delete set null;
alter table Project ADD constraint FK_Dnum foreign key(Dnum) references Department(Dnumber) on update cascade on delete set null;
alter table Works_On add constraint FK_ESSN foreign key(ESSN) references Employee(SSN) on update cascade on delete set null;
alter table Works_On Add constraint FK_Pno foreign key(Pno) references Project(Pno) on update cascade on delete set null;

-- Inserting Values

insert into Employee values 
('Sy', 'R', 101, 'Blr', 'F', 50000, 100, 1),
('Sys', 'N', 102, 'Mlr', 'M', 45000, 100, 1),
('As', 'K', 201, 'Blr', 'M', 45000, 200, 2),
('Sk', 'R', 301, 'Blm', 'F', 45000, 300, 3),
('R', 'B', 401, 'Dvd', 'M', 35000, 400, 4),
('Ts', 'K', 501, 'NI', 'M', 22500, 500, 5);

insert into project values
(1, 'Rprt-Generation', 1),
(2, 'OS Updation', 1),
(3, 'NetPay-Gate', 2),
(4, 'Pentesting', 3),
(5, 'API Arch', 4),
(6, 'Team-Syncing', 5);

insert into Works_On values
(100, 1, 3),(100, 2, 3),
(101, 1, 3),(102, 2, 5),
(200, 3, 5),(201, 3, 6),
(300, 4, 5),(301, 4, 6),
(400, 5, 4),(401, 5, 5),
(500, 6, 4),(501, 6, 4);

-- Displaying the tables.
select * from Department;
select * from Employee;
select * from Project;
select * from Works_On;


-- QUERIES.

--Query 1 : To get names of all employees whose salary is > salary of all the employees of dept 5.
select concat(fname, ' ', lname) as "Emp Name" from Employee 
	where salary > (select sum(salary) from Employee where dno=5);

--Query 2 : To get the ssns of all employees who work on project numbers 1, 2 or 3.
select ESSN from Works_On
	where Pno=1 or Pno=2 or Pno=3;
-- OR
select ESSN from Works_On
	where Pno in (1, 2, 3);

--Query 3 : To find total hours put in by all employees on Each project.
select Pno,sum(hours) from Works_On group by Pno;
	

-- 6a Queries :

-- Creating a Dependents table.
CREATE TABLE IF NOT EXISTS Dependents (
	Dno int, ESSN int,
  	foreign key(Dno) references Department(Dnumber) on update cascade on delete set null,
	foreign key(ESSN) references Employee(SSN) on update cascade on delete set null
);

-- Inserting values.

insert into Dependents values
(4, 401),
(3, 300),
(1, 101),
(5, 500),
(2, 201);

-- ALTERNATIVELY, if wanted ... 
-- -- Making Dname as both UNIQUE and NOT NULL, so as to reference it as a foreign key in Dependent table.
-- alter table Dept add constraint Uniq_Dname unique(Dname);
-- alter table Dept alter column Dname set not null;

-- alter table Dept add constraint FK_Dname foreign key(Dname) references Dept(Dname);


-- Query 1 : To find the average salary of all employees under each dept.
select Dname, avg(salary) from Department dept, Employee emp 
	where emp.Dno = dept.Dnumber group by Dname;

-- Query 2 : To List the names of managers w/ atleast one dependent.
select SSN, concat(Fname, ' ', Lname) as 'Emp Name' from Employee 
where SSN in
  (select ESSN from Dependents where ESSN in 
    (select MgrSSN from Department)
	);

-- Query 3 : To get details of all depts having 'tech' as a substring in their name.
select * from Department where Dname LIKE '%tech%';