# Mysql-Script
 A simple script to pipe data from the attached CSV into the MySQL tables provided 

Description:
All data from the CSV must be processed into the provided tables. (contact_list.csv)
▪ Data must be sanitized to be safely inserted 
▪ Data must be consistent when exported as is when imported. 
▪ First and Last names must have the first letter capitalized. 
▪ Business Names must have acronyms be capitalized. 
▪ Mobile numbers must have a 64 prefixed 
▪ Landline numbers must have 09 prefixed 
▪ The `contact_id` field in the address and phone tables must match to an existing record with the same value in the `id` field of the contact table  
▪ MySQL 5.7 is to be used 

** Important: **
Csv files will need to be picked on from :
C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/contact_list.csv   -- Directory
