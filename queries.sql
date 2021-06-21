/* how to do log into MySQL terminal client (or sometimes known command line interface, aka CLI) */
mysql -u root

-- to exit command line interface
exit

/* display all the databases in the server */
show databases;

/* create a new database */
create database employee_feedback;

/* switch to the database */
/* use <name of database>; */
use employee_feedback;

/* create the students table */
/* must specify engine as innodb for the foreign keys to work */
create table students (
  student_id int unsigned auto_increment primary key,
  first_name varchar(200) not null,
  last_name varchar(200) not null,
  bio text
) engine = innodb;

/* show all tables in the currently selected database */
show tables;

/* insert rows into tables */
/* insert into <table name> (<columns>) values (<values>) */
insert into students (first_name, last_name, bio) 
    values ("Ah Kow", "Tan", "Year one student");

/* display all rows and all columns from a table */
select * from students;

/* we can choose not to insert into columns that are nullable */
insert into students (first_name, last_name) values ("Mary", "Su");

/* insert many rows at once. Each row is one set of parethenesis */
insert into students (first_name, last_name, bio) values 
    ("John", "Doe", "Unknown person"),
    ("Alice", "Tay", null),
    ("Jane", "Smith", "Unknown person from a different era");


/* Class Practice - Creating table for Courses - https://classroom.google.com/w/MzIyNzE4OTYwMDcy/t/all */
-- Guides: mysqlprofessionalnote pdf
-- chap 25 how to create tables
-- chap 10 how to insert
create table courses (
    courses_id int unsigned auto_increment primary key,
    title varchar(100) not null,
    description tinytext
) engine = innodb;

/* can select just description */
select description from courses;

insert into courses (title, description) values 
    ("Psychology 101", "Introduction to psychology"),
    ("Statistics", null),
    ("Cognitive Psychology","Learn about the brain");


create table professors (
    professor_id int unsigned auto_increment primary key,
    first_name varchar(200) not null,
    last_name varchar(200) not null,
    salutation varchar (4) not null
) engine = innodb;

insert into professors (first_name, last_name, salutation) values
    ("Charles", "Oh", "Mr.");


create table feedback_statuses (
    feedback_status_id int unsigned auto_increment primary key,
    text text not null
) engine=innodb;


-- see all columns but not the content
describe feedback_statuses;


insert into feedback_statuses (text) values 
    ('Pending'),
    ('Acknowledged'),
    ('Resolved'),
    ('Escalated');

-- Foreign key

create table modules (
    module_id int unsigned auto_increment primary key,
    name varchar(200) not null,
    description tinytext not null,
    professor_id int unsigned not null, 
    foreign key (professor_id) references professors(professor_id)
) engine=innodb;

-- Invalid example
insert into modules (name, description, professor_id) values
    ("Interviews 101", "How to conduct interviews", 1);

-- there must be a professor_id of 2 that exist if not it does work


/* DELETE */
-- only delete student whose student_id is 4 (if there are multiple data with student_id 4, all of these data will be deleted)
delete from students where student_id = 4;

-- once a data is deleted, there is a gap


/* We cannot delete rows where there are other rows dependent on it*/
delete from professors where professor_id = 1;
-- either delete all the modules related to this professor first, or assign modules to another prof first before deleting professorId = 1


/* CREATE CLASSES */
create table classes (
    class_id int unsigned auto_increment primary key,
    semester varchar(10) not null,
    course_id int unsigned not null,
    foreign key(course_id) references courses(courses_id) on delete cascade,
    module_id int unsigned not null,
    foreign key(module_id) references modules(module_id) on delete cascade
) engine=innodb;

-- delete cascade delete all the classes associated with it once the foreign key is deleted

-- Own practice creating feedback table
create table feedback (
    feedback_id int unsigned auto_increment primary key,
    title varchar(200) not null,
    content text not null,
    date_posted datetime not null,
    student_id int unsigned not null,
    foreign key (student_id) references students(student_id),
    class_id int unsigned not null,
    foreign key (class_id) references classes(class_id),
    feedback_status_id int unsigned not null,
    foreign key (feedback_status_id) references feedback_statuses(feedback_status_id)
) engine=innodb;

insert into feedback (title, content, date_posted, student_id, class_id, feedback_status_id) values
    ('HP3703', 'Class need longer breaks in between', '2021-06-21', 1, 1, 1),
    ('HP4204','Need breaks in between class','2021-04-09',5,1,3),
    ('HP1001','Lecturer is unclear','2020-02-12',3,1,2);

delete from feedback where feedback_id = 2;

alter table feedback modify column date_posted date;




-- ==============
/* Paul's Code */
-- ==============

/* how to do log into MySQL terminal client (or sometimes known command line interface, aka CLI) */
mysql -u root

/* display all the databases in the server */
show databases;

/* create a new database */
create database employee_feedback;

/* switch to the database */
/* use <name of database>; */
use employee_feedback;

/* create the students table */
/* must specify engine as innodb for the foreign keys to work */
create table students (
  student_id int unsigned auto_increment primary key,
  first_name varchar(200) not null,
  last_name varchar(200) not null,
  bio text
) engine = innodb;

/* show all tables in the currently selected database */
show tables;

/* insert rows into tables */
/* insert into <table name> (<columns>) values (<values>) */
insert into students (first_name, last_name, bio) 
    values ("Ah Kow", "Tan", "Year one student");

/* display all rows and all columns from a table */
select * from students;

/* we can choose not to insert into columns that are nullable */
insert into students (first_name, last_name) values ("Mary", "Su");

/* insert many rows at once. Each row is one set of parethenesis */
insert into students (first_name, last_name, bio) values 
    ("John", "Doe", "Unknown person"),
    ("Alice", "Tay", null),
    ("Jane", "Smith", "Unknown person from a different era");


/* create courses */

create table courses (
    course_id int unsigned auto_increment primary key,
    title varchar(100) not null,
    description tinytext not null
) engine=innodb;

insert into courses (title, description) values 
('Management', 'Managing money, people and resources'),
('HR', 'Human resources 101'),
('Marketing', 'Marketing 101');

/* create the professors table */
create table professors (
    professor_id int unsigned auto_increment primary key,
    first_name varchar(200) not null,
    last_name varchar(200) not null,
    salulation varchar(4) not null
) engine=innodb;

insert into professors (first_name, last_name, salulation) values ('Tom', 'Jerry', 'Mr.');

create table feedback_statuses (
    feedback_status_id int unsigned auto_increment primary key,
    text text not null
) engine=innodb;

/* see all the columns but not the content */
describe feedback_statuses;

insert into feedback_statuses (text) 
    values ('Pending'),
    ('Acknowledged'),
    ('Resolved'),
    ('Escalated');

/* Foreign Key */
create table modules (
    module_id int unsigned auto_increment primary key,
    name varchar(200) not null,
    description tinytext not null,
    professor_id int unsigned not null,
    foreign key(professor_id) references professors(professor_id)
) engine=innodb;

/* INVALID EXAMPLE */
insert into modules (name, description, professor_id) values
     ("Interviews 101", "How to conduct interviews", 2);

/* VALID */
/* It's valid because there is a row in the professors table which professor_id is 1) */
insert into modules (name, description, professor_id) values
     ("Interviews 101", "How to conduct interviews", 1);

/* DELETE */
/* ONLY delete the student whose student_id is 4 */
delete from students where student_id = 4;

/* We cannot delete rows where there are other rows depended on it */
delete from professors where professor_id = 1;

/* Create CLASSES */
create table classes (
    class_id int unsigned auto_increment primary key,
    semester varchar(10) not null,
    course_id int unsigned not null,
    foreign key(course_id) references courses(course_id) on delete cascade,
    module_id int unsigned not null,
    foreign key(module_id) references modules(module_id) on delete cascade
) engine=innodb;

insert into classes (semester, course_id, module_id) values ("AY2021-B", 3, 2);

/* rename columns */
alter table classes rename column semester to semester_code;
/*
 alter table classes add column new_of_column unsigned int 
*/

/* UPDATE A ROW */
update students set bio = "Stays in AMK" where student_id = 2;
-- if you don't put "where", all students will be updated


-- DDL = Data Definition Language => create table, update table, insert into


