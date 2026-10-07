-- =====================================================
-- B2 - fn_years_of_service: complete years since hire date
-- NULL hire date -> NULL ; future hire date -> 0 (has not started yet)
-- =====================================================
CREATE OR REPLACE FUNCTION fn_years_of_service (
    p_hire_date IN DATE
) RETURN NUMBER
IS
BEGIN
    IF p_hire_date IS NULL THEN
        RETURN NULL;
    END IF;

    IF p_hire_date > SYSDATE THEN
        RETURN 0;
    END IF;

    RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, p_hire_date) / 12);
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END fn_years_of_service;
/
SHOW ERRORS FUNCTION fn_years_of_service
