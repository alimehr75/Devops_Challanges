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
  > SELECT FROM * info;
* ## create table 2 (employee_name, salary, start_date);
* ## insert to the table
* ## trunkate second table
* ## Delete row 5 from first table
