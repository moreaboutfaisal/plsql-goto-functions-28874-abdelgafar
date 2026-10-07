-- B5 - Functions used inside SQL (SELECT, WHERE, ORDER BY) | Abdelgafar 28874
SET LINESIZE 200
SET PAGESIZE 50
COLUMN emp_id         FORMAT 999
COLUMN first_name     FORMAT A10
COLUMN last_name      FORMAT A12
COLUMN department     FORMAT A16
COLUMN monthly_salary FORMAT 9,999,999
COLUMN annual_salary  FORMAT 99,999,999
COLUMN annual_tax     FORMAT 9,999,999
COLUMN years_service  FORMAT 99

SELECT e.emp_id, e.first_name, e.last_name,
       fn_dept_name(e.dept_id)                              AS department,
       e.monthly_salary,
       fn_annual_salary(e.monthly_salary)                   AS annual_salary,
       fn_calculate_tax(fn_annual_salary(e.monthly_salary)) AS annual_tax,
       fn_years_of_service(e.hire_date)                     AS years_service
FROM   employees e
ORDER  BY e.emp_id;

SELECT e.emp_id, e.first_name, fn_annual_salary(e.monthly_salary) AS annual_salary
FROM   employees e
WHERE  fn_annual_salary(e.monthly_salary) > 8000000
ORDER  BY fn_annual_salary(e.monthly_salary) DESC;
