
DELIMITER $$

BEGIN;

DROP DATABASE IF EXISTS joseqdb;

CREATE DATABASE IF NOT EXISTS joseqdb; 
#Reuse DB

USE joseqdb;

# Clearing all tables for use
DROP TABLE IF EXISTS joseqdb.address;
DROP TABLE IF EXISTS joseqdb.contact;
DROP TABLE IF EXISTS joseqdb.phone;
DROP TABLE IF EXISTS joseqdb.contact_list;

#Creating Table in such case ms second was created again
#good programming standard also

CREATE TABLE IF NOT EXISTS  
	joseqdb.contact_list ( 
			id INT(11) NOT NULL AUTO_INCREMENT,
			company_name VARCHAR(64),
			title VARCHAR(4),
			first_name VARCHAR(64),
			last_name VARCHAR(64),
			date_of_birth VARCHAR(16),
			street1 VARCHAR(100),
			street2 VARCHAR(100),
			suburb VARCHAR(64),
			city VARCHAR(64),
			post_code VARCHAR(16),
            home_number VARCHAR(16),
            fax_number VARCHAR(16),
            work_number VARCHAR(16),
            mobile_number VARCHAR(16),
            other_number VARCHAR(16),
			notes LONGTEXT,
			PRIMARY KEY(id) 
			); 

CREATE TABLE IF NOT EXISTS  
	joseqdb.contact ( 
			id INT(11) NOT NULL AUTO_INCREMENT,  
			 title ENUM('mr', 'mrs', 'miss', 'ms', 'dr'),
			 first_name VARCHAR(64),
			 last_name VARCHAR(64),
			 company_name VARCHAR(64),
			 date_of_birth DATETIME,
			 notes VARCHAR(255),
			 PRIMARY KEY(id) 
			); 

CREATE TABLE IF NOT EXISTS 
	joseqdb.address ( 
			id INT(11) NOT NULL AUTO_INCREMENT,
			contact_id INT(11) NOT NULL,
			street1 VARCHAR(100),
			street2 VARCHAR(100),
			suburb VARCHAR(64),
			city VARCHAR(64),
			post_code VARCHAR(16),
			PRIMARY KEY(id) 
            );

CREATE TABLE IF NOT EXISTS 
	joseqdb.phone ( 
		  id INT(11) NOT NULL AUTO_INCREMENT,
		  contact_id INT(11) NOT NULL,
		  name VARCHAR(64),
          content VARCHAR(64),
          type ENUM('Home', 'Work', 'Mobile', 'Other'),
          PRIMARY KEY(id) 
          );
          
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/contact_list.csv'
INTO TABLE joseqdb.contact_list
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(company_name,
		title,
		first_name,
		last_name,
		date_of_birth,
		street1,
		street2,
		suburb,
		city,
		post_code,
		home_number,
		fax_number,
		work_number,
		mobile_number,
		other_number,
		notes
        );
#SET date_of_birth = STR_TO_DATE(@date_of_birth, '%m/%d/%Y');
#SET notes = REPLACE(notes,'DROP TABLE',' ');

# I had some issues configuring my file to be pciked up by MySQL, I've tried numerous instances
# where It would let me pick up the csv file
# "secure_file_priv" was set to the file stated
# SHOW VARIABLES LIKE "secure_file_priv";
# SHOW VARIABLES LIKE 'local_infile';

#DECLARE n INT(10) DEFAULT 0;

DROP PROCEDURE IF EXISTS get_rec;

CREATE PROCEDURE get_rec ()

BEGIN
DECLARE n,i INT(10) DEFAULT 0;

DECLARE title_ VARCHAR(16);	
DECLARE first_name_ VARCHAR(64);
DECLARE last_name_ VARCHAR(64);
DECLARE company_name_ VARCHAR(64);
DECLARE dob_ DATETIME;
DECLARE notes_ VARCHAR(255);

#DECLARE contact_id_ INT(11);
DECLARE name_ VARCHAR(64);
DECLARE content_ VARCHAR(64);
DECLARE type_ VARCHAR(5);
DECLARE home_number_ VARCHAR(16);
DECLARE fax_number_ VARCHAR(16);
DECLARE work_number_ VARCHAR(16);
DECLARE mobile_number_ VARCHAR(16);
DECLARE other_number_ VARCHAR(16);

DECLARE address_line_1 VARCHAR(100);
DECLARE address_line_2 VARCHAR(100);
DECLARE suburb_ VARCHAR(64);
DECLARE city_ VARCHAR(64);
DECLARE post_code_ VARCHAR(16);

DECLARE compare1 VARCHAR(16);
DECLARE compare2 VARCHAR(16);

SELECT COUNT(*) FROM joseqdb.contact_list into n;

SET i = 1;

WHILE i < n DO 
   SELECT REPLACE(title,'.',' ') FROM joseqdb.contact_list
   WHERE id = i
   INTO title_;
   
   SELECT CONCAT(UCASE(LEFT(first_name, 1)),SUBSTRING(first_name, 2)) as first_name FROM joseqdb.contact_list
   WHERE id = i
   INTO first_name_;
   
   SELECT CONCAT(UCASE(LEFT(last_name, 1)),SUBSTRING(last_name, 2)) as last_name FROM joseqdb.contact_list
   WHERE id = i
   INTO last_name_;
   
   SELECT UCASE(company_name) FROM joseqdb.contact_list
   WHERE id = i
   INTO company_name_;
   
   SELECT STR_TO_DATE(@date_of_birth, '%m/%d/%Y') FROM joseqdb.contact_list
   WHERE id = i
   INTO dob_;
   
   SELECT REPLACE(notes,';','') FROM joseqdb.contact_list
   WHERE id = i
   INTO notes_;
   
  INSERT INTO joseqdb.contact(id,title,first_name,last_name,company_name,date_of_birth,notes) 
  VALUES('',title_,first_name_,last_name_,company_name_,dob_,notes_);
  COMMIT;
  
  SELECT first_name,home_number,fax_number,work_number,mobile_number,other_number FROM joseqdb.contact_list
  WHERE id = i
  INTO name_,home_number_,fax_number_,work_number_,mobile_number_,other_number_;
  
  # The IS NOT NULL STATEMENT doesn't work as there is empty data inside
  # So I will have to compare with emtpy or white space
  
  IF home_number_ <> '' THEN 
	 SELECT SUBSTRING(home_number_,1,4) FROM joseqdb.contact_list
	 WHERE id = i
	 INTO compare1;
        
	 SELECT SUBSTRING(home_number_,1,2) FROM joseqdb.contact_list
	 WHERE id = i
	 INTO compare2;
     
	IF compare1 = '(09)' OR @compare2 = '09' THEN
		INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
		VALUES('',i,name_,home_number_,'Home');
		COMMIT;
	ELSE
		SELECT concat('(09)',home_number) FROM joseqdb.contact_list
		WHERE id = i
		INTO home_number_;
    
		INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
		VALUES('',i,name_,home_number_,'Home');
		COMMIT;
	END IF;
  END IF;
    
  IF mobile_number_ <> '' THEN 
	 SELECT SUBSTRING(mobile_number_,1,2) FROM joseqdb.contact_list
	 WHERE id = i
	 INTO compare1;
     
	IF compare1 = '64' THEN
		INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
		VALUES('',i,name_,mobile_number_,'Mobile');
		COMMIT;
	ELSE
		SELECT concat('(09)',mobile_number) FROM joseqdb.contact_list
		WHERE id = i
		INTO home_number_;
    
		INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
		VALUES('',i,name_,mobile_number_,'Mobile');
		COMMIT;
	END IF;
  END IF;   
    
  IF fax_number_ <> '' THEN 
	INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
	VALUES('',i,name_,fax_number_,'Other');
	COMMIT;
  END IF; 
  
  IF work_number_ <> '' THEN 
	INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
	VALUES('',i,name_,work_number_,'Work');
	COMMIT;
  END IF; 
  
  IF other_number_ <>'' THEN 
	INSERT INTO joseqdb.phone(id,contact_id,name,content,type) 
	VALUES('',i,name_,other_number_,'Other');
	COMMIT;
  END IF; 

  SELECT street1,street2,suburb,city,post_code FROM joseqdb.contact_list
  WHERE id = i
  INTO address_line_1,address_line_2,suburb_,city_,post_code_;

  INSERT INTO joseqdb.address
  (id,contact_id,street1,street2,suburb,city,post_code)
  VALUES ('',i,address_line_1,address_line_2,suburb_,city_,post_code_);
  
  SET i = i + 1;
END WHILE;

END;
#DECLARE @number_of_recs int
#set @number_of_recs = SELECT COUNT(*) from joseqdb.contact_list;

  CALL  get_rec();

  DROP TABLE joseqdb.contact_list;

  SELECT * FROM joseqdb.contact;
  SELECT * FROM joseqdb.address;
  SELECT * FROM joseqdb.phone;

END$$
DELIMITER ;


