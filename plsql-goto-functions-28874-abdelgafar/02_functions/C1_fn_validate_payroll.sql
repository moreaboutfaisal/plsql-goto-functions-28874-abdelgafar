-- =====================================================
-- C1 - fn_validate_payroll: combined task (GOTO + functions + exceptions)
-- Returns 'VALID' or 'INVALID: <reason>'
-- Needs B1, B3 and B4 to be created first.
-- =====================================================
CREATE OR REPLACE FUNCTION fn_validate_payroll (
    p_emp_id IN NUMBER
) RETURN VARCHAR2
IS
    v_salary    employees.monthly_salary%TYPE;
    v_hire      employees.hire_date%TYPE;
    v_dept      employees.dept_id%TYPE;
    v_dept_name VARCHAR2(50);
    v_annual    NUMBER;
    v_tax       NUMBER;
    v_msg       VARCHAR2(200);
BEGIN
    SELECT monthly_salary, hire_date, dept_id
    INTO   v_salary, v_hire, v_dept
    FROM   employees
    WHERE  emp_id = p_emp_id;

    -- Check 1: salary
    IF v_salary IS NULL OR v_salary <= 0 THEN
        v_msg := 'Salary is missing or not greater than zero';
        GOTO invalid_result;
    END IF;

    -- Check 2: hire date
    IF v_hire IS NULL THEN
        v_msg := 'Hire date is missing';
        GOTO invalid_result;
    ELSIF v_hire > SYSDATE THEN
        v_msg := 'Hire date is in the future';
        GOTO invalid_result;
    END IF;

    -- Check 3: department
    IF v_dept IS NULL THEN
        v_msg := 'Employee has no department';
        GOTO invalid_result;
    END IF;

    v_dept_name := fn_dept_name(v_dept);
    IF v_dept_name = 'Unknown' THEN
        v_msg := 'Department ' || v_dept || ' does not exist';
        GOTO invalid_result;
    END IF;

    -- Check 4: tax must be less than annual salary
    v_annual := fn_annual_salary(v_salary);
    v_tax    := fn_calculate_tax(v_annual);
    IF v_tax >= v_annual THEN
        v_msg := 'Calculated tax is not less than annual salary';
        GOTO invalid_result;
    END IF;

    RETURN 'VALID';

    <<invalid_result>>
    RETURN 'INVALID: ' || v_msg;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'INVALID: Employee ' || p_emp_id || ' not found';
    WHEN OTHERS THEN
        RETURN 'INVALID: Unexpected error - ' || SQLERRM;
END fn_validate_payroll;
/
SHOW ERRORS FUNCTION fn_validate_payroll
