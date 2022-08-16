* ## first of all change prompt to be convenient:
  > prompt mysql \u [\d] > </br>
  > \u : shows current user 
  > \d : shows current database
* ## create database
  > CREATE DATABASE devops;
* ## create a user with remote access to server
  > CREATE USER 'gholi'@'%' IDENTIFIED BY '(Gholi)+1234!';
* ## grant ALL PRIVILEGES access for user to the created database
  > * USE devops;
  > * GRANT ALL PRIVILEGES ON devops.*  TO 'gholi'@'%' WITH GRANT OPTION;
  > * FLUSH PRIVILEGES;
* ## Connect to mysql with created user 
  >  mysql -h 192.168.1.107 -u gholi -p 
* ## create a table with these columns (id, name, age, phone) 
  > CREATE TABLE info ( </br>
  > id INT AUTO_INCREMENT NOT NULL PRIMARY KEY ,</br> 
  > name VARCHAR(10), </br>
  > age INT , </br>
  > phone VARCHAR(12) </br>
  > ) AUTO_INCREMENT=1000 ; </br>
  > 
* ## insert data to this table 
  > INSERT INTO info VALUES </br> 
  > (NULL,'Ali',25,'09212000037'),</br> 
  > (NULL,'Gholi',48,'091200000045'), </br>
  > (NULL,'Gholam',49,'09350001225');
* 
* ## select (* , order by, limit) from table
  > SELECT * FROM info; </br>
  > SELECT name,age FROM info ORDER BY age ASC; </br>
  > SELECT name,age FROM info ORDER BY name ASC;</br>
  > SELECT name,age FROM info ORDER BY name ASC LIMIT 2; </br>
  > SELECT name,age FROM info ORDER BY name DESC LIMIT 3 ; </br>
* ## create table 2 (employee_name, salary, start_date);
  > CREATE TABLE employees ( employee_name CHAR(255) NOT NULL, salary INT , start_date DATE NOT NULL );

* ## insert to the table
  > INSERT INTO employees VALUES </br>
  > ('Gholam',10000000,'2020-02-01 08:00:00'),</br>
  > ('Gholi',15000000,'2019-05-01 08:00:00'),</br>
  > ('Yadollah',17000000,'2017-03-01 08:00:00');</br>

* ## truncate second table
  > TRUNCATE TABLE employees; 


* ## Delete row 5 from first table
  > DELETE FROM info WHERE id=1005; </br>
  > or we cam use where with name :)
