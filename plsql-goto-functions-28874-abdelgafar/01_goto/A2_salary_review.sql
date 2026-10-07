-- =====================================================
-- A2 - Salary Review (uses GOTO)
-- Rules:  NULL or <= 0 salary -> skip employee
--         < 500,000           -> 10% raise
--         500,000 - 999,999   -> 5% raise
--         >= 1,000,000        -> no raise
-- Nothing is updated in the table; the program only reports the proposed salary.
-- =====================================================
SET SERVEROUTPUT ON

DECLARE
    v_pct NUMBER;
    v_new NUMBER;
BEGIN
    FOR r IN (SELECT emp_id, first_name, last_name, monthly_salary
              FROM   employees
              ORDER  BY emp_id) LOOP

        IF r.monthly_salary IS NULL OR r.monthly_salary <= 0 THEN
            GOTO skip_employee;
        END IF;

        IF r.monthly_salary < 500000 THEN
            v_pct := 10;
            GOTO apply_raise;
        ELSIF r.monthly_salary < 1000000 THEN
            v_pct := 5;
            GOTO apply_raise;
        ELSE
            GOTO no_raise;
        END IF;

        <<apply_raise>>
        v_new := r.monthly_salary * (1 + v_pct / 100);
        DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                             ': ' || r.monthly_salary || ' -> ' || v_new ||
                             ' (' || v_pct || '% raise)');
        GOTO next_employee;

        <<no_raise>>
        DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                             ': ' || r.monthly_salary || ' -> no raise (already high)');
        GOTO next_employee;

        <<skip_employee>>
        DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                             ': SKIPPED (invalid or missing salary)');

        <<next_employee>>
        NULL;
    END LOOP;
END;
/
