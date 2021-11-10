-- Alter database to copy MDY datetime from CSV files
ALTER DATABASE employee_db SET datestyle TO 'iso, mdy';

-- Create tables and import CSV files
CREATE TABLE employees (
	emp_no INT PRIMARY KEY,
	emp_title_id VARCHAR(10),
	birth_date DATE,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	sex VARCHAR(1),
	hire_date DATE
);

CREATE TABLE departments (
	dept_no VARCHAR(10) PRIMARY KEY,
	dept_name VARCHAR(20)	
);

CREATE TABLE dept_emp (
	emp_no INT REFERENCES employees (emp_no),
	dept_no VARCHAR(10) REFERENCES departments (dept_no)	
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(10) REFERENCES departments (dept_no),
	emp_no INT REFERENCES employees (emp_no)
);

CREATE TABLE salaries (
	emp_no INT REFERENCES employees (emp_no),
	salary INT
);

CREATE TABLE titles (
	title_id VARCHAR(10) PRIMARY KEY,
	title VARCHAR(20)
);

-- Altered employees table to link foreign key, referencing titles table
ALTER TABLE employees
ADD FOREIGN KEY (emp_title_id) REFERENCES titles (title_id);

-- Check for duplicate employees
SELECT * FROM employees AS ou
WHERE (SELECT COUNT(emp_no) FROM employees AS inr
WHERE ou.emp_no = inr.emp_no) > 1;

-- List employee number, last name, first name, sex, and salary
SELECT employees.emp_no, last_name, first_name, sex, salary FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- List first name, last name, and hire date for employees who were hired in 1986
SELECT first_name, last_name, hire_date FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name.
SELECT dept_manager.dept_no, dept_name, dept_manager.emp_no, last_name, first_name FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees ON employees.emp_no = dept_manager.emp_no

--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, last_name, first_name, dept_name FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_emp.dept_no

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, last_name, first_name, dept_name FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales'

--List all employees in the Sales and Development departments, including their 
--employee number, last name, first name, and department name.
SELECT employees.emp_no, last_name, first_name, dept_name FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development'

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) AS last_name_count FROM employees
GROUP BY last_name
ORDER BY last_name_count DESC;
