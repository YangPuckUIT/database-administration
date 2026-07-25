                                -- Nguyễn Dương Phúc 24521386
-- 1. Create a query to display the customer name and ID. The column names should be 
-- "Customer Name" and "Customer ID". Sort the results in descending order of customer ID.
SELECT name AS "Customer Name", 
        id AS "Customer ID"
FROM s_customer 
ORDER BY "Customer ID" DESC

-- 2. Create a view to display the login name of employee 23.
CREATE OR REPLACE VIEW emp23_login AS
SELECT userid AS "Login Name"
FROM s_emp
WHERE id = '23';

-- 3. Create a view to display the last name, first name, and department code of employees in department 10 and 50, ordered by their names. 
-- Concatenate the first and last names into a new column called "Employees". 
-- Note: When giving an alias for a column (e.g., "Employees"), you can use the AS keyword, but when giving an alias for a table, 
-- you cannot use AS and should simply have a space between the table name and its alias. Use the || operator to concatenate the two columns.
CREATE OR REPLACE VIEW emp_dept10_50 AS
SELECT last_name,
       first_name,
       dept_id,
       first_name || ' ' || last_name AS "Employees"
FROM s_emp
WHERE dept_id IN ('10', '50')
ORDER BY "Employees";

-- 4. Create a view to display all employees whose names contain the letter "S".
CREATE OR REPLACE VIEW emp_S AS
SELECT last_name || ' ' || first_name AS "Employee Name"
FROM s_emp
WHERE UPPER(last_name) LIKE '%S%'
   OR UPPER(first_name) LIKE '%S%';
   
-- 5. Create a view to display the login name and start date of employees who started working
-- between 14/5/1990 and 26/5/1991.
CREATE OR REPLACE VIEW emp_login_namedate AS
SELECT userid,
       start_date
FROM s_emp
WHERE start_date BETWEEN TO_DATE('14/5/1990','DD/MM/YYYY') 
                     AND TO_DATE('26/5/1991','DD/MM/YYYY');
                     
-- 6. Write a query to display the names and salaries of all employees who have a salary between 1000 and 2000 per month.
CREATE OR REPLACE VIEW emp_salary AS
SELECT last_name || ' ' || first_name AS "Employee Name",
       salary
FROM s_emp
WHERE salary BETWEEN 1000 AND 2000;

-- 7. Create a list of names and salaries for employees in departments 31, 42, and 50 who earn more than 1350. 
-- Name the column for names as "Employee Name" and the column for salary as "Monthly Salary".
SELECT last_name || ' ' || first_name AS "Employee Name",
       salary AS "Monthly Salary"
FROM s_emp
WHERE dept_id IN ('31', '42', '50')
  AND salary > 1350;
  
-- 8. Display the name and start date of each employee hired in the year 1991.
SELECT last_name || ' ' || first_name AS "Employee Name",
       start_date
FROM s_emp
WHERE TO_CHAR(start_date,'YYYY') = '1991';

-- 9. Display the employee ID, name, and salary increased by 15%.
SELECT id,
       last_name || ' ' || first_name AS "Employee Name",
       salary * 1.15 AS "Salary increase 15%"
FROM s_emp

-- 10. Display the name of each employee, hiring date, and the date of salary review. 
-- The salary review date is defined as the second Monday after 6 months of employment. 
-- Format the salary review date as "8th of May 1992".
SELECT 
    last_name || ' ' || first_name AS "Employee Name",
    start_date AS "Hire Date",
    TO_CHAR(
        NEXT_DAY(ADD_MONTHS(start_date, 6), 'MONDAY') + 7,
        'DDth "of" Month YYYY'
    ) AS "Salary Review Date"
FROM s_emp;

-- 11. Display the names of all products that contain the word "ski".
SELECT name
FROM s_product
WHERE name LIKE '%Ski%';

-- 12. For each employee, calculate the number of months they have worked. 
-- Sort the results in ascending order of the number of months worked, rounding the number of months.
SELECT last_name || ' ' || first_name AS "Employee Name",
       ROUND(MONTHS_BETWEEN(SYSDATE, start_date)) AS "Months Worked"
FROM s_emp
ORDER BY "Months Worked" ASC;

-- 13. Find out how many managers there are.
SELECT COUNT(DISTINCT manager_id) AS "Number of Managers"
FROM s_emp
WHERE manager_id IS NOT NULL;

-- 14. Display the highest and lowest order amounts in the S_ORD table. 
-- Name the corresponding columns as "Highest" and "Lowest".
SELECT 
    MAX(total) AS "Highest",
    MIN(total) AS "Lowest"
FROM s_ord;

-- 15. Display the product name, product ID, and the quantity of each product in the order with order number 101. 
-- The quantity column should be named "ORDERED".
SELECT p.name AS "Product Name",
       p.id AS "Product ID",
       i.quantity AS "ORDERED"
FROM s_item i
JOIN s_product p
  ON i.product_id = p.id
WHERE i.ord_id = '101';

-- 16. Display the customer ID and order ID for all customers, including those who have not placed an order. 
-- Sort the list by customer ID.
SELECT c.id AS "Customer ID",
       o.id AS "Order ID"
FROM s_customer c
LEFT JOIN s_ord o
  ON c.id = o.customer_id
ORDER BY c.id;

-- 17. Display the customer ID, product ID, and quantity ordered for orders with a total value above 100,000.
SELECT o.customer_id AS "Customer ID",
       i.product_id AS "Product ID",
       i.quantity AS "Quantity Ordered"
FROM s_ord o
JOIN s_item i
  ON o.id = i.ord_id
WHERE o.total > 100000;

-- 18. Display the full names of all employees who are not managers.
SELECT last_name || ' ' || first_name AS "Full Name"
FROM s_emp
WHERE id NOT IN (SELECT DISTINCT manager_id 
                 FROM s_emp
                 WHERE manager_id IS NOT NULL);

-- 19. Display all products whose names start with the word "Pro" in alphabetical order.
SELECT name
FROM s_product
WHERE name LIKE 'Pro%'
ORDER BY name ASC;

-- 20. Display the product name and short description (SHORT_DESC) of products whose short description contains the word "bicycle".
SELECT name AS "Product Name",
       short_desc AS "Short Description"
FROM s_product
WHERE LOWER(short_desc) LIKE '%bicycle%';

-- 21. Display all the SHORT_DESC values.
SELECT short_desc
FROM s_product;

-- 22. Display the name of employees and their titles in parentheses for all employees. Example: Nguyễn Văn Tâm (Director).
SELECT last_name || ' ' || first_name || ' (' || title || ')' AS "Employee Info"
FROM s_emp;

-- 23. For each manager, show the manager's ID and the number of employees they manage.
SELECT manager_id,
       COUNT(*) AS "Number of Employees"
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 24. Display managers who manage 20 or more employees.
SELECT manager_id,
       COUNT(*) AS "Number of Employees"
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING COUNT(*) >= 20;

-- 25. Show the region code, region name, and the number of departments in each region.
SELECT r.id AS "Region ID",
       r.name AS "Region Name",
       COUNT(d.id) AS "Number of Departments"
FROM s_region r
LEFT JOIN s_dept d ON r.id = d.region_id
GROUP BY r.id, r.name;

-- 26. Display the customer name and the number of orders placed by each customer.
SELECT c.name AS "Customer Name",
       COUNT(o.id) AS "Number of Orders"
FROM s_customer c
JOIN s_ord o ON c.id = o.customer_id
GROUP BY c.name;

-- 27. Find out which customer has the most orders.
SELECT c.id AS "Customer ID", 
       c.name AS "Customer Name",
       COUNT(o.id) AS "Number of Orders"
FROM s_customer c
JOIN s_ord o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) = (
    SELECT MAX(order_count) 
    FROM (
        SELECT COUNT(id) AS order_count
        FROM s_ord
        GROUP BY customer_id
    )
);

-- 28. Find out which customer has the highest total purchase amount.
SELECT c.id AS "Customer ID", 
       c.name AS "Customer Name",
       SUM(o.total) AS "Total Purchase"
FROM s_customer c
JOIN s_ord o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING SUM(o.total) = (
    SELECT MAX(total_sum)
    FROM (
        SELECT SUM(total) AS total_sum
        FROM s_ord
        GROUP BY customer_id
    )
);
-- 29. Display the last name, first name, and hire date of all employees who are in the same department as Ben.
SELECT last_name, first_name, start_date
FROM s_emp
WHERE dept_id = (
    SELECT dept_id
    FROM s_emp
    WHERE first_name = 'Ben'
);

-- 30. Display the employee ID, last name, first name, and user ID of all employees whose salary is above the average salary.
SELECT id, last_name, first_name, userid
FROM s_emp
WHERE salary > (
    SELECT AVG(salary)
    FROM s_emp
);

-- 31. Display the employee ID, last name, and first name of all employees who have a salary above the average and whose name contains the letter “L”.
SELECT id, last_name, first_name
FROM s_emp
WHERE salary > (
    SELECT AVG(salary)
    FROM s_emp
)
AND (UPPER(last_name) LIKE '%L%' OR UPPER(first_name) LIKE '%L%');

-- 32. Display customers who have never placed an order.
SELECT id, name
FROM s_customer
WHERE id NOT IN (
    SELECT DISTINCT customer_id
    FROM s_ord
);