# Mysql-Script
 A simple script to pipe data from the attached CSV into the MySQL tables provided 

Description:
All data from the CSV is processed into the provided tables. (contact_list.csv)
▪ Data is sanitized to be safely inserted 
▪ Data is consistent when exported as is when imported. 
▪ First and Last names have the first letter capitalized. 
▪ Business Names have acronyms be capitalized. 
▪ Mobile numbers  have a 64 prefixed 
▪ Landline numbers have 09 prefixed 
▪ The `contact_id` field in the address and phone tables matches existing record with the same value in the `id` field of the contact table  
▪ MySQL 5.7 is use

** Important: **
Csv files will need to be picked on from :
C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/contact_list.csv   -- Directory
