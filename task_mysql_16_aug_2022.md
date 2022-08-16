## first of all change prompt to be convenient:
  > `prompt mysql \u [\d] > `</br>
  > `\u : shows current user `</br>
  > `\d : shows current database` </br>
## create database
  > `CREATE DATABASE devops;`
## create a user with remote access to server
  > `CREATE USER 'gholi'@'%' IDENTIFIED BY '(Gholi)+1234!';`
## grant ALL PRIVILEGES access for user to the created database
> </br></br>`USE devops;`</br>
> `GRANT ALL PRIVILEGES ON devops.*  TO 'gholi'@'%' WITH GRANT OPTION;`</br>
> `FLUSH PRIVILEGES;`</br></br></br>
> [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/1.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/1.png)


## Connect to mysql with created user 
  > </br>`mysql -h 192.168.1.107 -u gholi -p ` </br></br>
  > [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/2.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/2.png)

## create a table with these columns (id, name, age, phone)
  ```
  CREATE TABLE info ( 
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY ,
  name VARCHAR(10), 
  age INT , 
  phone VARCHAR(12) 
  ) AUTO_INCREMENT=1000 ; 
  ``` 
  > [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/4.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/4.png)
## insert data to this table 
  ```
  INSERT INTO info VALUES 
  (NULL,'Ali',25,'09212000037'),
  (NULL,'Gholi',48,'091200000045'), 
  (NULL,'Gholam',49,'09350001225');
  ```
  [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/5.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/5.png)

## select (* , order by, limit) from table
  > </br></br> `SELECT * FROM info;`</br>
  > `SELECT name,age FROM info ORDER BY age ASC; `</br>
  > `SELECT name,age FROM info ORDER BY name ASC;`</br></br>
  [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/6.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/6.png)</br></br></br></br>
  > `SELECT name,age FROM info ORDER BY name ASC LIMIT 2;` </br>
  > `SELECT name,age FROM info ORDER BY name DESC LIMIT 3 ;` </br></br></br>
  [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/7.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/7.png)</br></br></br>
## create table 2 (employee_name, salary, start_date);
```
CREATE TABLE employees ( 
employee_name CHAR(255) NOT NULL, 
salary INT , 
tart_date DATE NOT NULL );
```


## insert to the table
```
INSERT INTO employees VALUES 
('Gholam',10000000,'2020-02-01 08:00:00'),
('Gholi',15000000,'2019-05-01 08:00:00'),
('Yadollah',17000000,'2017-03-01 08:00:00');
```
> </br>[![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/8.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/8.png)

## truncate second table
  > </br>`TRUNCATE TABLE employees; `</br>
  > </br> [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/9.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/9.png)


## Delete row 5 from first table
  > </br>`DELETE FROM info WHERE id=1005;` </br>
  > </br> [![Far Now](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/10.png?raw=true)](https://github.com/alimehr75/Devops_Challanges/blob/main/mysql_task/10.png)</br>
  > or we cam use where with name :)
