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
SELECT first_name, last_name, emp_no
-- Copies the output of our query to a new table retirement_info
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SQL allows for using Aliases for table names
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
-- Defining aliases here ('as d', 'as dm')
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- SQL allows GROUPBY just like Pandas
-- Employee count by department number
-- We count the # of employees in each department, returning both the count and the dept number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
-- We can also format the output by ordering by a certain value, with ORDER BY
ORDER BY de.dept_no;

-- Creating a new table with our filtered data (employees eligible for retirement, incl gender)
SELECT emp_no, 
	first_name, 
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Completing our join with the Salaries and Dept_Emp tables, using aliases
-- Docs for joining two or more tables: https://www.postgresqltutorial.com/postgresql-inner-join/
SELECT e.emp_no,
    e.first_name,
	e.last_name,	
    e.gender,
    s.salary,
    de.to_date
--INTO emp_info
FROM employees as e
-- We opt for an INNER JOIN because we ONLY want matching records
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
-- Adding a second join is as simple as adding it directly below the first
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');

-- Finding the managers that are set to retire
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- Adding department names to the current_employees table
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

------------

-- Use of DISTINCT and DISTINCT ON
-- SELECT (Distinct) documentation: https://www.postgresql.org/docs/9.5/sql-select.html#SQL-DISTINCT
-- Syntax:
	-- Should always repeat the item; DISTINCT ON (item) item, <next item>, <next item>
SELECT DISTINCT ON (location) location, time, report
    FROM weather_reports
	-- If we don't use ORDER BY, DISTINCT ON may not select the appropriate row
	-- Typically is best prctice to combine DISTINCT ON with ORDER BY
	-- Follow same syntax as the SELECT query
    ORDER BY location, time DESC;

------------

-- Aggregate functions
-- https://www.youtube.com/watch?v=nNrgRVIzeHg