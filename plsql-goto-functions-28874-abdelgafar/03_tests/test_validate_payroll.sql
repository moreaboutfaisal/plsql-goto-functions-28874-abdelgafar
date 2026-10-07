-- =====================================================
-- test_validate_payroll.sql - tests C1 on all employees + a missing id
-- Expected: 101-105 VALID; 106 no dept; 107 no salary; 108 zero salary;
--           109 dept 99; 110 future hire date; 999 not found
-- =====================================================
SET SERVEROUTPUT ON
SET LINESIZE 200
COLUMN result FORMAT A60

SELECT emp_id, first_name, fn_validate_payroll(emp_id) AS result
FROM   employees
ORDER  BY emp_id;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee 999 => ' || fn_validate_payroll(999));
END;
/
