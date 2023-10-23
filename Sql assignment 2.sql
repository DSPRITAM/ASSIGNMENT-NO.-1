use assignments;

-- Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
-- The CountryCode for America is USA.
select * from city
where population > 100000 and countrycode="USA";


-- Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
-- The CountryCode for America is USA.
select name from city
where population > 120000 and countrycode="USA";


-- Q3. Query all columns (attributes) for every row in the CITY table.
select * from city;


-- Q4. Query all columns for a city in CITY with the ID 1661.
select * from city where id=1661;


-- Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
select * from city where countrycode = "JPN";


-- Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.
select name from city
where countrycode = "JPN";


-- Q7. Query a list of CITY and STATE from the STATION table.
select city,state from station;


-- Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
-- in any order, but exclude duplicates from the answer.
select distinct city from station
where id % 2 = 0;


-- Q9. Find the difference between the total number of CITY entries in the table and the number of
-- distinct CITY entries in the table
SELECT COUNT(*) - COUNT(DISTINCT CITY) 
FROM STATION;

 
 
--  Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
-- respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
-- largest city, choose the one that comes first when ordered alphabetically.
SELECT CITY, LENGTH(CITY) AS NameLength
FROM STATION
ORDER BY NameLength ASC, CITY
LIMIT 1;

SELECT CITY, LENGTH(CITY) AS NameLength
FROM STATION
ORDER BY NameLength DESC, CITY
LIMIT 1;



-- Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
-- cannot contain duplicates.
select distinct city from station
where city regexp '^[aeiou]';


-- Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot
-- contain duplicates.
select distinct city from station
where city regexp '[aeiou]$';



-- Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot
-- contain duplicates.
select distinct city from station
where city not regexp '^[aeiou]';


-- Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot
-- contain duplicates.
select distinct city from station
where city not regexp '[aeiou]$';


-- Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end
-- with vowels. Your result cannot contain duplicates.
select distinct city from station
where city not regexp '^[aeiou]'
or city not regexp '[aeiou]$';


-- Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with
-- vowels. Your result cannot contain duplicates.
select distinct city from station
where city not regexp '^[aeiou]'
and city not regexp '[aeiou]$';


-- Q17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
-- between 2019-01-01 and 2019-03-31 inclusive.
-- Return the result table in any order.

use assignments;
create table Product(
product_id int,
product_name varchar(30),
unit_price int,
primary key(product_id));
create table Sales(
seller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int,
foreign key(product_id) references Product(product_id));

insert into Product values(1,"S8",1000),(2,'G4',800),(3,"iphone",1400);
insert into Sales values(1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-02-17',1,800),(2,2,3,'2019-06-02',1,800),(3,3,4,'2019-05-13',2,2800);
select * from Product;
select * from Sales;

select p.product_id, p.product_name FROM
Product p
INNER JOIN
Sales s
on p.product_id = s.product_id
where s.sale_date >= '2019-01-01' and s.sale_date <= '2019-03-31'
except
select p.product_id, p.product_name FROM
Product p
INNER JOIN
Sales s
on p.product_id = s.product_id
where s.sale_date < '2019-01-01' OR s.sale_date > '2019-03-31';


-- Q18.Write an SQL query to find all the authors that viewed at least one of their own articles.
-- Return the result table sorted by id in ascending order.
create table Views(
article_id int,
author_id int,
viewer_id int,
view_date date);
insert into Views values(1,3,5,"2019-08-01"),(1,3,6,"2019-08-02"),(2,7,7,"2019-08-01"),(2,7,6,"2019-08-02"),(4,7,1,"2019-07-22"),(3,4,4,"2019-07-21"),(3,4,4,"2019-07-21");
select * from Views;
select distinct author_id from Views
where  author_id=viewer_id
order by author_id;


-- Q19.Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
-- places.
create table Delivery(
delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date,
primary key(delivery_id));
insert into Delivery values(1, 1, '2019-08-01', '2019-08-02'),(2,5,'2019-08-02','2019-08-02'),(3, 1, '2019-08-11', '2019-08-11'),(4,3,'2019-08-24','2019-08-26'),(5,4,'2019-08-21','2019-08-22'),(6,2,'2019-08-11','2019-08-13');
select * from Delivery;
select round((select count(*) from delivery 
where order_date = customer_pref_delivery_date)/count(*)*100,2) as immediate_percentage 
from delivery;


-- Q20.Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
-- Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a
-- tie.
create table Ads(
ad_id int,
user_id int,
action varchar(20),
primary key(ad_id, user_id)
);
insert into Ads values(1,1,"Clicked"),(2,2,"Clicked"),(3,3,"Viewed"),(5,5,"Ignored"),(1,7,"Ignored"),(2,7,"Viewed"),(3,5,"Clicked"),(1,4,"Viewed"),(2,11,"Viewed"),(1,2,"Clicked");
select * from Ads;
select t.ad_id, (case
when base != 0 then round(t.num/t.base*100,2) else 0 end) as Ctr from (select
ad_id,
sum( case when action = 'clicked' or action = 'viewed' then 1 else 0 end) as
base,
sum( case when action = 'clicked' then 1 else 0 end) as num
from ads
group by ad_id)t
order by Ctr desc, t.ad_id asc;



-- Q21.Write an SQL query to find the team size of each of the employees.
-- Return result table in any order.
create table Employee(
employee_id int,
team_id int);
insert into Employee values(1,8),(2,8),(3,8),(4,7),(5,9),(6,9);
select * from Employee;
select employee_id, count(team_id) over (partition by team_id) as team_size 
from employee order by employee_id;


-- Q22.Write an SQL query to find the type of weather in each country for November 2019.The
-- type of weather is:
create table Countries1(
country_id int,
country_name varchar(30),
primary key(country_id));
create table Weather1(
country_id int,
weather_state int,
day date,
primary key(country_id,day));
insert into Countries values (2,"USA"),(3,"Australia"),(7,"Peru"),(5,"China"),(8,"Morocco"),(9,"Spain");
insert into Weather values (2,15,'2019-11-01'),(2,12,'2019-10-28'),
(2,12,'2019-10-27'),(3,-2,'2019-11-10'),(3,0,'2019-11-11'),(3,3,'2019-11-12'),
(5,16,'2019-11-07'),(5,18,'2019-11-09'),(5,21,'2019-11-23'),(7,25,'2019-11-28'),
(7,22,'2019-12-01'),(7,20,'2019-12-02'),(8,25,'2019-11-05'),(8,27,'2019-11-15'),
(8,31,'2019-11-25'),(9,7,'2019-10-23'),(9,3,'2019-12-23');

select c.country_name, case
when avg(weather_state) <= 15 then 'Cold'
when avg(weather_state) >= 25 then 'Hot'
else 'Warm'
end as weather_state
from
countries c
left join
weather w
on c.country_id = w.country_id
where month(day) = 11
group by c.country_name;



-- Q23.Write an SQL query to find the average selling price for each product. average_price should be rounded
-- to 2 decimal places.
create table Prices(
product_id int,
start_date date,
end_date date,
Price int,
primary key(product_id,start_date,end_date));
insert into Prices values (1,'2019-02-17','2019-02-28',5),(1,'2019-03-01','2019-03-22',20),(2,'2019-02-01','2019-02-20',15),(2,'2019-02-21','2019-03-31',30);
create table Unitsold(
product_id int,
purchase_date date,
Units int);
insert into unitssold values (1,'2019-02-25',100),(1,'2019-03-01',15),(2,'2019-02-10',200),(2,'2019-03-22',30);

select p.product_id, round(sum(u.units*p.price)/sum(u.units),2) as average_price
from
prices p 
left join
unitssold u
on p.product_id = u.product_id
where u.purchase_date >= start_date and u.purchase_date <= end_date
group by product_id
order by product_id;


-- Q24.Write an SQL query to report the first login date for each player.
-- Return the result table in any order.
create table Activity1(
player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id,event_date));
insert into Activity1 values (1,2,'2016-03-01',5),
(1,2,'2016-05-02',6),
(2,3,'2017-06-25',1),
(3,1,'2016-03-02',0),
(3,4,'2018-07-03',5);

select t.player_id, event_date as first_login from (select player_id, 
event_date, row_number() over(partition by player_id order by event_date) as num 
from activity1)t where t.num = 1; 


-- Q25.Write an SQL query to report the device that is first logged in for each player
create table Activity2(
player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id,event_date));
insert into Activity2 values (1,2,'2016-03-01',5),
(1,2,'2016-05-02',6),
(2,3,'2017-06-25',1),
(3,1,'2016-03-02',0),
(3,4,'2018-07-03',5);

select t.player_id, t.device_id 
from (select player_id, device_id, row_number() over(partition by player_id 
order by event_date) as num from activity)t
where t.num = 1;


-- Q26.Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
-- and their amount.
create table Products3 (
product_id int,
product_name varchar(30),
product_category varchar(30),
primary key(product_id));
create table Orders3 (
product_id int,
order_date date,
unit int); 
insert into Products3 values (1,'Leetcode Solutions','Book'),
(2,'Jewels of Stringology','Book'),
(3,'HP','Laptop'),
(4,'Lenovo','Laptop'),
(5,'Leetcode Kit','T-shirt');
insert into Orders3 values (1,'2020-02-05',60),
(1,'2020-02-10',70),
(2,'2020-01-18',30),
(2,'2020-02-11',80),
(3,'2020-02-17',2),
(3,'2020-02-24',3),
(4,'2020-03-01',20),
(4,'2020-03-04',30),
(4,'2020-03-04',60),
(5,'2020-02-25',50),
(5,'2020-02-27',50),
(5,'2020-03-01',50);

select p.product_name, sum(o.unit) as unit
from
Products3 p
left join
Orders3 o
on p.product_id = o.product_id
where month(o.order_date) = 2 and year(o.order_date) = 2020
group by p.product_id
having unit >= 100;


-- Q27.Write an SQL query to find the users who have valid emails.A
-- valid e-mail has a prefix name and a domain where:
-- ● The prefix name is a string that may contain letters (upper or lower case), digits, underscore
-- '_', period '.', and/or dash '-'. The prefix name must start with a letter.

create table Users4(
user_id int,
Name Varchar(30),
Mail varchar(30),
primary key(user_id));
insert into Users4 values(1,"Winston","winston@leetcode.com"),
(2,"Jonathan","jonathanisgreat"),
(3,"Annabella","bella-@leetcode.com"),
(4,"Sally","sally.com@leetcode.com"),
(5,"Marwan","quarz#2020@leetcode.com"),
(6,"David","david69@gmail.com"),
(7,"Shapiro",".shapo@leetcode.com");

select user_id, name, mail from Users4 
where
mail regexp '^[a-zA-Z]+[a-zA-Z0-9_\.\-]*@leetcode[\.]com'
order by user_id;


-- Q28. Write an SQL query to report the customer_id and customer_name of customers who have spent at
-- least $100 in each month of June and July 2020.
-- Return the result table in any order.

create table Customers10(
customer_id int,
Name varchar(30),
Country varchar(30),
primary key(customer_id));
create table Product10(
product_id int,
Name varchar(30),
Price int,
primary key(product_id));

create table Orders10(
order_id int,
customer_id int,
product_id int,
order_date date,
Quantity int,
primary key(order_id));
insert into Customers10 values (1,"Winston","USA"),
(2,"Jonathan","Peru"),
(3,"Moustafa","Egypt");
insert into Product10 values (10,"LC Phone",300),
(20,"LC T-shirt",10),
(30,"LC Book",45),
(40,"LC Keychain",2);
insert into Orders10 values (1,1,10,'2020-06-10',1),
(2,1,20,'2020-07-01',1),
(3,1,30,'2020-07-08',2),
(4,2,10,'2020-06-15',2),
(5,2,40,'2020-07-01',10),
(6,3,20,'2020-06-24',2),
(7,3,30,'2020-06-25',2),
(9,3,30,'2020-05-08',3);

select t.customer_id, t.name from
(select c.customer_id, c.name, 
sum(case when month(o.order_date) = 6 and year(o.order_date) = 2020 then
p.price*o.quantity else 0 end) as june_spent,
sum(case when month(o.order_date) = 7 and year(o.order_date) = 2020 then
p.price*o.quantity else 0 end) as july_spent
from
Orders10 o
left join
Product10 p
on o.product_id = p.product_id
left join
Customers10 c
on o.customer_id = c.customer_id
group by c.customer_id) t
where june_spent >= 100 and july_spent >= 100;


-- Q29. Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020. Return
-- the result table in any order
create table TVProgram11(
program_date date,
content_id int,
channel varchar(30));
create table Content11(
content_id int,
Title varchar(30),
kids_content varchar(1),
content_type varchar(30),
primary key(content_id));
insert into TVProgram11 values('2020-06-10 08:00',1,"LC-Channel"),
('2020-05-11 12:00',2,"LC-Channel"),
('2020-05-12 12:00',3,"LC-Channel"),
('2020-05-13 14:00',4,"Disney Ch"),
('2020-06-18 14:00',4,"Disney Ch"),
('2020-07-15 16:00',5,"Disney Ch");
insert into Content11 values(1,"Leetcode Movie","N","Movies"),
(2,"Alg. for Kids ","Y","Series"),
(3,"Database Sols","N","Series"),
(4,"Aladdin","Y","Movies"),
(5,"Cindrella","Y","Movies");

select c.Title from
Content11 c
left join
TVProgram11 t
on c.content_id = t.content_id
where c.Kids_content = 'Y' and c.content_type = 'Movies' and
month(t.program_date) = 6 and year(t.program_date) = 2020;



-- Q30. Write an SQL query to find the npv of each query of the Queries table.Return
-- the result table in any order.
create table NPV (
id int,
Year int,
Npv int,
primary key(id,Year));
create table Queries (
id int,
Year int,
primary key(id,Year));
insert into NPV values (1,2018,100),
(7,2020,30),
(13,2019,40),
(1,2019,113),
(2,2008,121),
(3,2009,12),
(11,2020,99),
(7,2019,0);
insert into Queries values (1,2019),
(2,2008),
(3,2009),
(7,2018),
(7,2019),
(7,2020),
(13,2019);

select q.*, coalesce(n.Npv,0) as Npv
from
Queries q
left join
NPV n
on q.Id = n.Id and q.Year = n.Year;


-- Q31. Write an SQL query to find the npv of each query of the Queries table.Return
-- the result table in any order.
create table NPV (
id int,
Year int,
Npv int,
primary key(id,Year));
create table Queries (
id int,
Year int,
primary key(id,Year));
insert into NPV values (1,2018,100),
(7,2020,30),
(13,2019,40),
(1,2019,113),
(2,2008,121),
(3,2009,12),
(11,2020,99),
(7,2019,0);
insert into Queries values (1,2019),
(2,2008),
(3,2009),
(7,2018),
(7,2019),
(7,2020),
(13,2019);

select q.*, coalesce(n.Npv,0) as Npv
from
Queries q
left join
NPV n
on q.Id = n.Id and q.Year = n.Year;


-- Q32. Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
-- show null.
-- Return the result table in any order.
create table Employees(
id int,
Name varchar(30),
primary key(id));
create table EmployeesUNI(
id int,
unique_id int,
primary key(id,unique_id));
insert into Employees values (1,"Alice"),
(7,"Bob"),
(11,"Meir"),
(90,"Winston"),
(3,"Jonathan");
insert into EmployeesUNI values (3,1),
(11,2),
(90,3);

select u.unique_id, e.name
from
employees e
left join
employeesUNI u
on e.id = u.id;


-- Q33. Write an SQL query to report the distance travelled by each user.
-- Return the result table ordered by travelled_distance in descending order, if two or more users
-- travelled the same distance, order them by their name in ascending order.

create table Users11(
id int,
Name varchar(30),
primary key(id));
create table Rides11(
id int,
user_id int,
distance int,
primary key(id));
insert into Users11 values (1,"Alice"),
(2,"Bob"),
(3,"Alex"),
(4,"Donald"),
(7,"Lee"),
(13,"Jonathan"),
(19,"Elvis");
insert into Rides11 values (1,1,120),
(2,2,8317),
(3,3,222),
(4,7,100),
(5,13,312),
(6,19,50),
(7,7,120),
(8,19,400),
(9,7,230);

select u.name, coalesce(sum(r.distance),0) as travelled_distance
from
users11 u
left join
rides11 r
on u.id = r.user_id
group by u.name
order by travelled_distance desc, u.name;


-- Q34. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
-- and their amount.
-- Return result table in any order.
create table Products12(
product_id int,
product_name varchar(30),
product_category varchar(30));
create table Orders12(
product_id int,
order_date date,
Unit int);
insert into Products12 values (1,"Leetcode Solutions","Book"),
(2,"Jewels of Stringology","Book"),
(3,"HP","Laptop"),
(4,"Lenovo","Laptop"),
(5,"Leetcode Kit","T-shirt");
insert into Orders12 values (1,'2020-02-05',60),
(1,'2020-02-10',70),
(2,'2020-01-18',30),
(2,'2020-02-11',80),
(3,'2020-02-17',2),
(3,'2020-02-24',3),
(4,'2020-03-01',20),
(4,'2020-03-04',30),
(4,'2020-03-04',60),
(5,'2020-02-25',50),
(5,'2020-02-27',50),
(5,'2020-03-01',50);

select p.product_name, sum(o.unit) as unit
from
Products12 p
left join
Orders12 o
on p.product_id = o.product_id
where month(o.order_date) = 2 and year(o.order_date) = 2020
group by p.product_id
having unit >= 100;


-- Q35. Write an SQL query to:
-- ● Find the name of the user who has rated the greatest number of movies. In case of a tie,
-- return the lexicographically smaller user name.
-- ● Find the movie name with the highest average rating in February 2020. In case of a tie, return
-- the lexicographically smaller movie name.
create table Movies12(
movie_id int,
Title varchar(30),
primary key(movie_id));
create table users12(
user_id int,
Name varchar(30),
primary key(user_id));
create table MovieRating(
movie_id int,
user_id int,
Rating int,
created_at date,
primary key(movie_id,user_id));
insert into Movies12 values (1,"Avengers"),
(2,"Frozen 2"),
(3,"Joker");
insert into Users12 values (1,"Daniel"),
(2,"Monica"),
(3,"Maria"),
(4,"James");
insert into MovieRating values (1,1,3,'2020-01-12'),
(1,2,4,'2020-02-11'),
(1,3,2,'2020-02-12'),
(1,4,1,'2020-01-01'),
(2,1,5,'2020-02-17'),
(2,2,2,'2020-02-01'),
(2,3,2,'2020-03-01'),
(3,1,3,'2020-02-22'),
(3,2,4,'2020-02-25');

(select t1.name as Results from
(select u.name, count(u.user_id), dense_rank() over(order by count(user_id) 
desc, u.name) as r1 FROM
Users12 u
left join
MovieRating m
on u.user_id = m.user_id
group by u.user_id) t1
where r1 = 1)
union
(select t2.title as Results from
(select mo.title, avg(m.rating), dense_rank() over(order by avg(m.rating)desc, 
mo.title) as r2 from
Movies12 mo
left join
MovieRating m
on mo.movie_id = m.movie_id
where month(m.created_at) = 2 and year(m.created_at) = 2020
group by m.movie_id) t2
where r2 = 1);


-- Q36. Write an SQL query to report the distance travelled by each user.
-- Return the result table ordered by travelled_distance in descending order, if two or more users
-- travelled the same distance, order them by their name in ascending order.

create table Users13 (
id int,
name varchar(30),
primary key(id));
create table Rides13(
id int,
user_id int,
distance int,
primary key(id));
insert into Users13 values (1,"Alice"),
(2,"Bob"),
(3,"Alex"),
(4,"Donald"),
(7,"Lee"),
(13,"Jonathan"),
(19,"Elvis");
insert into Rides13 values (1,1,120),
(2,2,317),
(3,3,222),
(4,7,100),
(5,13,312),
(6,19,50),
(7,7,120),
(8,19,400),
(9,7,230);

select u.name, coalesce(sum(r.distance),0) as travelled_distance
from
users13 u
left join
rides13 r
on u.id = r.user_id
group by u.name
order by travelled_distance desc, u.name;


-- Q37. Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
-- show null.
-- Return the result table in any order.

create table Employees13(
id int,
name varchar(30),
primary key(id));
create table EmployeeUNI(
id int,
unique_id int,
primary key(id,unique_id));
insert into Employees13 values (1,"Alice"),
(7,"Bob"),
(11,"Meir"),
(90,"Winston"),
(3,"Jonathan");
insert into EmployeeUNI values (3,1),(11,2),(90,3);

select u.unique_id, e.name
from
employees13 e
left join
employeeUNI u
on e.id = u.id;


-- Q38. Write an SQL query to find the id and the name of all students who are enrolled in departments that no
-- longer exist.
-- Return the result table in any order.

create table Departments13 (
id int,
name varchar(30),
primary key(id));
create table Students13 (
id int,
name varchar(30),
department_id int,
primary key(id));
insert into Departments13 values (1,"Electrical Engineering"),
(7,"Computer Engineering"),
(13,"Bussiness Administration");
insert into Students13 values (23,"Alice",1),
(1,"Bob",7),
(5,"Jennifer",13),
(2,"John",14),
(4,"Jasmine",77),
(3,"Steve",74),
(6,"Luis",1),
(8,"Jonathan",7),
(7,"Daiana",33),
(11,"Madelynn",1);

select id, name from Students13
where department_id not in (select id from Departments13);


-- Q39. Write an SQL query to report the number of calls and the total call duration between each pair of
-- distinct persons (person1, person2) where person1 < person2.
-- Return the result table in any order.

create table Calls13 (
from_id int,
to_id int,
duration int
);
insert into Calls13 values (1,2,59),
(2,1,11),
(1,3,20),
(3,4,100),
(3,4,200),
(3,4,200),
(4,3,499);

select t.person1, t.person2, count(*) as call_count, sum(t.duration) as
total_duration
from
(select duration,
case when from_id < to_id then from_id else to_id end as person1,
case when from_id > to_id then from_id else to_id end as person2
from Calls13) t
group by t.person1, t.person2;


-- Q40. Write an SQL query to find the average selling price for each product. average_price should be rounded
-- to 2 decimal places.
-- Return the result table in any order.

create table Prices13 (
product_id int,
start_date date,
end_date date,
price int,
primary key(product_id,start_date,end_date));
create table UnitsSold13 (
product_id int,
purchase_date date,
Units int);
insert into Prices13 values (1,'2019-02-17','2019-02-28',5),
(1,'2019-03-01','2019-03-22',20),
(2,'2019-02-01','2019-02-20',15),
(2,'2019-02-21','2019-03-31',30);
insert into unitssold13 values (1,'2019-02-25',100),
(1,'2019-03-01',15),
(2,'2019-02-10',200),
(2,'2019-03-22',30);

select p.product_id, round(sum(u.units*p.price)/sum(u.units),2) as average_price
from
prices13 p 
left join
unitssold13 u
on p.product_id = u.product_id
where u.purchase_date >= start_date and u.purchase_date <= end_date
group by product_id
order by product_id;



-- Q41. Write an SQL query to report the number of cubic feet of volume the inventory occupies in each
-- warehouse.
-- Return the result table in any order.

create table Warehouse14 (
Name varchar(30),
product_id int,
Units int,
primary key(Name,product_id));
create table Products14 (
product_id int,
product_name varchar(30),
width int,
length int,
Height int,
primary key(product_id)
);
insert into warehouse14 values ("LCHouse1",1,1),
("LCHouse1",2,10),
("LCHouse1",3,5),
("LCHouse2",1,2),
("LCHouse2",2,2),
("LCHouse3",4,1);
insert into Products14 values (1,"LC-TV",5,50,40),
(2,"LC-keychain",5,5,5),
(3,"LC-phone",2,10,10),
(4,"LC-T-shirt",4,10,20);

select w.name as warehouse_name, sum(p.width*p.length*p.height*w.units) as
volume 
from
warehouse14 w
left join
products14 p
on w.product_id = p.product_id
group by w.name
order by w.name;


-- Q42. Write an SQL query to report the difference between the number of apples and oranges sold each day.
-- Return the result table ordered by sale_date.
create table Sales14 (
sale_date date,
fruit varchar(20),
sold_num int,
primary key(sale_date, fruit));
insert into Sales14 values ('2020-05-01',"apples",10),
('2020-05-01',"oranges",8),
('2020-05-02',"apples",15),
('2020-05-02',"oranges",15),
('2020-05-03',"apples",20),
('2020-05-03',"oranges",0),
('2020-05-04',"apples",15),
('2020-05-04',"oranges",16);

select t.sale_date, (t.apples_sold - t.oranges_sold) as diff
from
(select sale_date,
max(CASE WHEN fruit = 'apples' THEN sold_num ELSE 0 END )as apples_sold,
max(CASE WHEN fruit = 'oranges' THEN sold_num ELSE 0 END )as oranges_sold
FROM sales14
group by sale_date) t
ORDER BY t.sale_date;


-- Q43. Write an SQL query to report the fraction of players that logged in again on the day after the day they
-- first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
-- that logged in for at least two consecutive days starting from their first login date, then divide that
-- number by the total number of players.

create table Activity14 (
player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id,event_date));
insert into Activity14 values (1,2,'2016-03-01',5),
(1,2,'2016-03-02',6),
(2,3,'2017-06-25',1),
(3,1,'2016-03-02',0),
(3,4,'2018-07-03',5);

select round(t.player_id/(select count(distinct player_id) from activity),2) as
fraction
from
(
select distinct player_id,
datediff(event_date, lead(event_date, 1) over(partition by player_id order by
event_date)) as diff
from activity14 ) t
where diff = -1;


-- Q44. Write an SQL query to report the managers with at least five direct reports.
-- Return the result table in any order.
create table Employee14 (
id int,
Name varchar(30),
Department varchar(30),
manager_id int,
primary key(id));
insert into Employee14 values (101,"John","A",null),
(102,"Dan","A",101),
(103,"James","A",101),
(104,"Amy","A",101),
(105,"Anne","A",101),
(106,"Ron","B",101);

select t.name from
(select a.id, a.name, count(b.managerID) as no_of_direct_reports from
employee14 a
INNER JOIN
employee14 b
on a.id = b.managerID
group by b.managerID) t
where no_of_direct_reports >= 5
order by t.name;


-- Q45. Write an SQL query to report the respective department name and number of students majoring in
-- each department for all departments in the Department table (even ones with no current students).
-- Return the result table ordered by student_number in descending order. In case of a tie, order them by
-- dept_name alphabetically.
create table Student14 (
student_id int,
student_name varchar(30),
gender varchar(30),
deep_id int,
primary key(student_id));
create table Department14 (
dept_id int,
dept_name varchar(30),
primary key(dept_id));
insert into Student14 values (1,"jack","M",1),
(2,"jane","F",1),
(3,"Mark","M",2);
insert into Department14 values (1,"Engineering"),
(2,"Science"),
(3,"Law");

select d.dept_name, count(s.dept_id) as student_number from
department14 d
left join
student14 s
on s.dept_id = d.dept_id
group by d.dept_id
order by student_number desc, dept_name;


-- Q46. Write an SQL query to report the customer ids from the Customer table that bought all the products in the
-- Product table.
-- Return the result table in any order.

create table customer15 (
customer_id int,
product_key int );
create table product15 (
product_key int,
primary key(product_key));
insert into customer15 values (1,5),
(2,6),
(3,5),
(3,6),
(1,6);
insert into product15 values (5),(6);

select customer_id
from
customer15
group by customer_id
having count(distinct product_key)=(select count(*) from product15);



-- Q47. Write an SQL query that reports the most experienced employees in each project. In case of a tie,
-- report all employees with the maximum number of experience years.
-- Return the result table in any order

create table project15 (
project_id int,
employee_id int,
primary key(project_id, employee_id));
create table Employee15 (
employee_id int,
name varchar(30),
experience_years int,
primary key(employee_id));
insert into project15 values (1,1),
(1,2),
(1,3),
(2,1),
(2,4);
insert into employee15 values (1,"khaled",3),
(2,"Ali",2),
(3,"John",3),
(4,"Doe",2);

select t.project_id, t.employee_id
from
(select p.project_id, e.employee_id, dense_rank() over(partition by p.project_id 
order by e.experience_years desc) as r
from
project15 p
left join
employee15 e
on p.employee_id = e.employee_id) t
where r = 1
order by t.project_id;



-- Q48. Write an SQL query that reports the books that have sold less than 10 copies in the last year,
-- excluding books that have been available for less than one month from today. Assume today is
-- 2019-06-23.
-- Return the result table in any order.

create table Books15 (book_id int,
name varchar(30),
available_date date,
primary key(book_id));
create table orders15 (
order_id int,
book_id int,
quantity int,
dispatch_date date,
primary key(order_id),
foreign key(book_id) references books15(book_id));
insert into Books15 values (1,"Kalila and demna",'2010-01-01'),
(2,"28 letters",'2012-05-12'),
(3,"The hobbit",'2019-06-10'),
(4,"13 reason why",'2019-06-01'),
(5,"The hunger games",'2008-09-21');
insert into orders15 values (1,1,2,'2019-07-26'),
(2,1,1,'2018-11-05'),
(3,3,8,'2019-06-11'),
(4,4,6,'2019-06-05'),
(5,4,5,'2019-06-20'),
(6,5,9,'2009-02-02'),
(7,5,8,'2010-04-13');

select t1.book_id, t1.name
from
(
(select book_id, name from Books15 where
available_from < '2019-05-23') t1
left join
(select book_id, sum(quantity) as quantity
from Orders15
where dispatch_date > '2018-06-23' and dispatch_date<= '2019-06-23'
group by book_id
having quantity < 10) t2
on t1.book_id = t2.book_id
);


-- Q49. Write a SQL query to find the highest grade with its corresponding course for each student. In case of a
-- tie, you should find the course with the smallest course_id.
-- Return the result table ordered by student_id in ascending order.

create table enrollments15 (
student_id int,
course_id int,
grade int,
primary key(student_id,course_id));
insert into enrollments15 values (2,2,95),
(2,3,95),
(1,1,90),
(1,2,99),
(3,1,80),
(3,2,75),
(3,3,82);

select t.student_id, t.course_id, t.grade
from
(select student_id, course_id, grade, dense_rank() over(partition by student_id 
order by grade desc, course_id) as r
from enrollments15) t
where r = 1
order by t.student_id;


-- Q50. Write an SQL query to find the winner in each group.Return
-- the result table in any order.

create table players15 (
player_id int,
group_id int,
primary key(player_id));
create table matches15 (
match_id int,
first_player int,
second_player int,
first_score int,
second_score int,
primary key(match_id));
insert into players15 values (15,1),
(25,1),
(30,1),
(45,1),
(10,2),
(35,2),
(50,2),
(20,3),
(40,3);
insert into matches15 values (1,15,45,3,0),
(2,30,25,1,2),
(3,30,15,2,0),
(4,40,20,5,2),
(5,35,50,1,1);

select t2.group_id, t2.player_id from
(
select t1.group_id, t1.player_id, 
dense_rank() over(partition by group_id order by score desc, player_id) as r
from
(
select p.*, case when p.player_id = m.first_player then m.first_score
when p.player_id = m.second_player then m.second_score
end as score
from
Players15 p, Matches15 m
where player_id in (first_player, second_player)) t1) t2
where r = 1; 