-- Select rows from columns first_name and last_name in table employees, who were born in 1952
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31'
	   
-- Select those that are eligible for retirement by combining two conditional statements
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	  
	   
-- Count the number of employees eligible for retirement:
	   -- We don't need last name as each first name comes with last name. COUNT() takes only one column as an argument.
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	 


-- Modifying the above query to return a table with our results
SELECT first_name, last_name
-- Copies the output of our query to a new table retirement_info
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');	 