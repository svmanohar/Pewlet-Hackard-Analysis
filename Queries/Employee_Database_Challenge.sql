-- Create a table of employees with all the titles they have held over the years of employment
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    ti.title,
    ti.from_date,
    ti.to_date
INTO retirement_titles
FROM employees as e
-- Since we want all values from both tables, we do a FULL OUTER JOIN
FULL OUTER JOIN titles as ti
    ON (e.emp_no = ti.emp_no)
    WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- Order tabel by employee numbers
ORDER BY e.emp_no

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO latest_retirement_titles 
FROM retirement_titles
-- ORDER BY is by default sorted ascending, so the lowest emp_no is presented first
-- Since to_date is ordered descending, we only get the latest date first
-- We then select ONLY those rows using Distinct ON()
ORDER BY emp_no, to_date DESC;

-- Count the number of employees set to retire sorted by title
-- Return both the count of titles and the title
SELECT COUNT(title), title
--INTO count-latest_retirement_titles
FROM latest_retirement_titles
-- Group the counts by title
GROUP BY title
ORDER BY COUNT(title) DESC;


-- Select distinct columns from emp_no when to_date is descending (latest values only)
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    t.title

INTO mentorship_eligibility
FROM employees as e
-- Complete two FULL OUTER JOINS to get the data we require
FULL OUTER JOIN dept_emp as de
    ON (e.emp_no = de.emp_no)
FULL OUTER JOIN titles as t
    ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no ASC, de.to_date DESC;
