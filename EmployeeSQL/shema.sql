DROP TABLE IF EXISTS titles;
DROP TABLE titles CASCADE;
CREATE TABLE titles(
	title_id VARCHAR(255),
	title VARCHAR(255),
	PRIMARY KEY (title_id));

SELECT * FROM titles;
-----------------------------------------------
DROP TABLE IF EXISTS employees;
DROP TABLE employees CASCADE;

CREATE TABLE employees(
	emp_no INT,
	emp_title_id VARCHAR(255),
	birth_date DATE,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR(255),
	hire_date DATE,
	PRIMARY KEY(emp_no),
	FOREIGN KEY(emp_title_id) REFERENCES titles(title_id));

SELECT * FROM employees;
-----------------------------------------------
DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
	dept_no VARCHAR(255),
	dept_name VARCHAR(255),
	PRIMARY KEY(dept_no));

SELECT * FROM departments;
-----------------------------------------------
DROP TABLE IF EXISTS dept_manager;
CREATE TABLE dept_manager(
	dept_no VARCHAR(255),
	emp_no INT,
	PRIMARY KEY(dept_no, emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no));

SELECT * FROM dept_manager;
-----------------------------------------------
DROP TABLE IF EXISTS dept_emp;
CREATE TABLE dept_emp(
	emp_no INT,
	dept_no VARCHAR(255),
	PRIMARY KEY(emp_no, dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no));
	
SELECT * FROM dept_emp;
-----------------------------------------------
DROP TABLE IF EXISTS salaries;
CREATE TABLE salaries(
	emp_no INT,
	salary INT,
	PRIMARY KEY(emp_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no));

SELECT * FROM salaries;
-------------------------------------------------------------------------------------------------------
-- List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT emp.emp_no,
		emp.birth_date,
		emp.last_name,
		emp.first_name,
		emp.sex,
		sal.salary
FROM employees AS emp
	LEFT JOIN salaries as sal
	ON (emp.emp_no = sal.emp_no)
ORDER BY emp.emp_no;
-------------------------------------------------------------------------------------------------------
-- List first name, last name, and hire date for employees who were hired in 1986.
SELECT emp.first_name,
		emp.last_name,
		emp.hire_date
FROM employees AS emp
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';
-------------------------------------------------------------------------------------------------------
-- List the manager of each department with the following information: department number, department name,
-- the manager's employee number, last name, first name.
SELECT dm.dept_no,
		dept.dept_name,
		dm.emp_no,
		emp.last_name,
		emp.first_name
FROM dept_manager AS dm
	INNER JOIN departments as dept
	ON (dm.dept_no = dept.dept_no)
	INNER JOIN employees AS emp
	ON (dm.emp_no = emp.emp_no);
-------------------------------------------------------------------------------------------------------
-- List the department of each employee with the following information: employee number, last name, first name, 
-- and department name.
SELECT emp.emp_no,
		emp.last_name,
		emp.first_name,
		dept.dept_name
FROM employees AS emp
	INNER JOIN dept_emp AS de
	ON (emp.emp_no = de.emp_no)
	INNER JOIN departments AS dept
	ON (de.dept_no = dept.dept_no);
-------------------------------------------------------------------------------------------------------
-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT emp.first_name,
		emp.last_name,
		emp.sex
FROM employees as emp
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';
-------------------------------------------------------------------------------------------------------
-- List all employees in the Sales department, including their employee number, last name, first name, 
-- and department name.
SELECT emp.emp_no,
		emp.last_name,
		emp.first_name,
		dept.dept_name
FROM employees AS emp
	INNER JOIN dept_emp AS de
	ON (emp.emp_no = de.emp_no)
	INNER JOIN departments AS dept
	ON (de.dept_no = dept.dept_no)
WHERE dept.dept_name = 'Sales';
-------------------------------------------------------------------------------------------------------
-- List all employees in the Sales and Development departments, including their employee number, 
-- last name, first name, and department name.
SELECT emp.emp_no,
		emp.last_name,
		emp.first_name,
		dept.dept_name
FROM employees AS emp
	INNER JOIN dept_emp AS de
	ON (emp.emp_no = de.emp_no)
	INNER JOIN departments AS dept
	ON (de.dept_no = dept.dept_no)
WHERE dept.dept_name IN ('Sales', 'Development');
-------------------------------------------------------------------------------------------------------
-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;