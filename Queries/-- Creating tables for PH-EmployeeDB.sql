-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

-- Create a table for employees
CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

-- Create a table for managers
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Create a table for salaries
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- Create a table for titles
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Create a table for Department Employee Duration
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);


-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT COUNT(first_name)
FROM retirement_info

-- Create a retirement_info table for the Sales department only
SELECT 	dept_name,
		employees.emp_no, 
        first_name, 
        last_name
INTO sales_retirement_info
FROM employees
-- Perform a left join from employees into dept_emp, on the emp_no column
LEFT JOIN dept_emp
ON (employees.emp_no = dept_emp.emp_no)
-- Perform a left join on the departments table, on the dept_no column
LEFT JOIN departments
ON (dept_emp.dept_no = departments.dept_no)
    -- Filtering rows by the following retirement parameters only (sales dept)
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    -- Currently employed employees only
    AND (to_date = '9999-01-01')
	AND (dept_name = 'Sales');

-- Create a retirement_info table for the Sales AND Development departments using IN/WHERE 
SELECT 	dept_name,
		employees.emp_no, 
        first_name, 
        last_name
INTO mentoring_retirement_info
FROM employees
-- Perform a left join from employees into dept_emp, on the emp_no column
LEFT JOIN dept_emp
ON (employees.emp_no = dept_emp.emp_no)
-- Perform a left join on the departments table, on the dept_no column
LEFT JOIN departments
ON (dept_emp.dept_no = departments.dept_no)
    -- Filtering rows by the following retirement parameters only (sales dept)
    -- 
    WHERE dept_name IN ('Sales', 'Development')
    AND (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    -- Currently employed employees only
    AND (to_date = '9999-01-01');


----------

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

select * from retirement_info

-- Joining retirement_info and dept_emp tables
-- Select the following columns to be returned from the retirement_info and dept_emp columns
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
-- Start our join; assign the LEFT table
FROM retirement_info
-- Calling a LEFT JOIN tells Postgres that the earlier stated table is the LEFT TABLE
-- The following table is the RIGHT Table
LEFT JOIN dept_emp
-- Specifies where the two tables are linked
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_dept_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
-- GROUPBY works like Pandas, grouping values by dept_no. 
-- Since we performed a COUNT, it groups the values by count
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Ordering an output by the to_date column in descending order (highest first)
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, 
	first_name, 
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

select * from emp_info

SELECT e.emp_no,
    e.first_name,
	e.last_name,	
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
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
		  
-- 

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

select * from manager_info

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