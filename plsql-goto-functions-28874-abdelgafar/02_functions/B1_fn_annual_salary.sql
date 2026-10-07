-- =====================================================
-- B1 - fn_annual_salary: monthly salary x 12
-- NULL -> 0 ; negative -> error -20001
-- =====================================================
CREATE OR REPLACE FUNCTION fn_annual_salary (
    p_monthly_salary IN NUMBER
) RETURN NUMBER
DETERMINISTIC
IS
BEGIN
    IF p_monthly_salary IS NULL THEN
        RETURN 0;
    END IF;

    IF p_monthly_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Monthly salary cannot be negative');
    END IF;

    RETURN p_monthly_salary * 12;
END fn_annual_salary;
/
SHOW ERRORS FUNCTION fn_annual_salary
