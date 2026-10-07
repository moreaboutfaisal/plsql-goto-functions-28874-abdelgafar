-- =====================================================
-- B3 - fn_calculate_tax: progressive income tax on ANNUAL salary
-- ASSUMED brackets (edit if your instructor gave different ones):
--   up to 720,000            -> 0%
--   720,001 to 1,200,000     -> 20% of the part above 720,000
--   above 1,200,000          -> 30% of the part above 1,200,000 (+ 96,000 from the 20% band)
-- =====================================================
CREATE OR REPLACE FUNCTION fn_calculate_tax (
    p_annual_salary IN NUMBER
) RETURN NUMBER
DETERMINISTIC
IS
    c_band1 CONSTANT NUMBER := 720000;
    c_band2 CONSTANT NUMBER := 1200000;
    v_tax   NUMBER;
BEGIN
    IF p_annual_salary IS NULL THEN
        RETURN 0;
    END IF;

    IF p_annual_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Annual salary cannot be negative');
    END IF;

    IF p_annual_salary <= c_band1 THEN
        v_tax := 0;
    ELSIF p_annual_salary <= c_band2 THEN
        v_tax := (p_annual_salary - c_band1) * 0.20;
    ELSE
        v_tax := (c_band2 - c_band1) * 0.20 + (p_annual_salary - c_band2) * 0.30;
    END IF;

    RETURN ROUND(v_tax, 2);
END fn_calculate_tax;
/
SHOW ERRORS FUNCTION fn_calculate_tax
