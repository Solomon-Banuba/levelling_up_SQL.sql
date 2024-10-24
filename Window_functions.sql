-- WINDOW FUNCTIONS AKA ANALYTICAL FUNCTIONS
/* Performs functiomns aggrgegrat operations on groups of rows but they produce a result  FOR EACH ROW. */



-- OVER CLAUSE: Constucts a window. When it's empty, the window will include all records

CREATE TABLE employees (
    emp_no INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(20),
    salary INT
);
 
INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);
 
 
 -- Average salaries for the entire table 
SELECT 
  emp_no, 
  department, 
  salary, 
  AVG(salary) OVER()
 FROM employees;
 
 
 -- MIN and MAX salaries for the entire table
 
SELECT 
    emp_no, 
    department, 
    salary, 
    MIN(salary) OVER(),
    MAX(salary) OVER()
FROM employees;
    
    
SELECT 
    emp_no,
    department, 
    salary, 
    MIN(salary), 
    MAX(salary)
FROM employees
GROUP BY   emp_no,
    department,  salary;
    
    
    
-- PARTITION BY CLAUSE WITH OVER: OVER(PARTITION BYS column_name)
-- Inside of the the OVER(), us the PARTITION BY to form rows into group of row
SELECT 
    emp_no, 
    department, 
    salary, 
    AVG(salary) OVER(PARTITION BY department) AS dept_avg,
    AVG(salary) OVER() AS company_avg
FROM employees;
 
SELECT 
    emp_no, 
    department, 
    salary, 
    COUNT(*) OVER(PARTITION BY department) as dept_count
FROM employees;
 


WITH aggr_cal AS(
  SELECT 
    emp_no
    , department
    , salary
    , ROUND(AVG(salary) OVER(PARTITION BY department), 2)AS dept_avg
    , ROUND(AVG(salary) OVER(),2 ) AS company_avg
  FROM employees
 
)

  SELECT 
    emp_no 
    , department
    , salary
    , dept_avg
    , company_avg
    , CASE 
        WHEN dept_avg > company_avg THEN 'high_earner'
        ELSE 'below_avg'
      END AS salary_status
 FROM aggr_cal;




-- OVER + PARTITION +ORDER BY 
-- ORDER BY inside of the OVER() cluase to re-order rows within each window
SELECT 
    emp_no
    , department
    , salary
    , SUM(salary) OVER(PARTITION BY department ORDER BY salary) AS rolling_dept_salary
    , SUM(salary) OVER(PARTITION BY department) AS total_dept_salary
FROM employees;

--
 
SELECT 
    emp_no, 
    department, 
    salary, 
    MIN(salary) OVER(PARTITION BY department ORDER BY salary DESC) as rolling_min
FROM employees;


-- RANK: Rank of current row within its partition, with gaps
SELECT 
    emp_no, 
    department, 
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY SALARY DESC) as dept_row_number,
    RANK() OVER(PARTITION BY department ORDER BY SALARY DESC) as dept_salary_rank,
    RANK() OVER(ORDER BY salary DESC) as overall_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) as overall_dense_rank,
    ROW_NUMBER() OVER(ORDER BY salary DESC) as overall_num
FROM employees ORDER BY overall_rank;


-- NTILE:
SELECT 
    emp_no, 
    department, 
    salary,
    NTILE(4) OVER(PARTITION BY department ORDER BY salary DESC) AS dept_salary_quartile,
	NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees;


-- FIRST_VALUE
SELECT 
    emp_no, 
    department, 
    salary,
    FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary DESC) as highest_paid_dept,
    FIRST_VALUE(emp_no) OVER(ORDER BY salary DESC) as highest_paid_overall
FROM employees;


-- LEAD & LAG
SELECT 
    emp_no, 
    department, 
    salary,
    salary - LAG(salary) OVER(ORDER BY salary DESC) as salary_diff
FROM employees;
 
SELECT 
    emp_no, 
    department, 
    salary,
    salary - LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) as dept_salary_diff
FROM employees;
