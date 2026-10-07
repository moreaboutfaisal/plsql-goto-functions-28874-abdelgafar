-- =====================================================
-- test_functions.sql - tests B1 to B4 (normal + edge cases)
-- =====================================================
SET SERVEROUTPUT ON

DECLARE
    PROCEDURE show(p_label VARCHAR2, p_value VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(RPAD(p_label, 45) || ' => ' || p_value);
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== B1 fn_annual_salary =====');
    show('fn_annual_salary(500000)',  fn_annual_salary(500000));   -- 6000000
    show('fn_annual_salary(NULL)',    fn_annual_salary(NULL));     -- 0
    BEGIN
        show('fn_annual_salary(-100)', fn_annual_salary(-100));
    EXCEPTION WHEN OTHERS THEN
        show('fn_annual_salary(-100)', 'ERROR: ' || SQLERRM);      -- ORA-20001
    END;

    DBMS_OUTPUT.PUT_LINE('===== B2 fn_years_of_service =====');
    show('hired 2015-03-15', fn_years_of_service(DATE '2015-03-15'));
    show('hired today',      fn_years_of_service(SYSDATE));         -- 0
    show('hired in 2030',    fn_years_of_service(DATE '2030-01-01'));-- 0
    show('NULL date',        NVL(TO_CHAR(fn_years_of_service(NULL)), 'NULL'));

    DBMS_OUTPUT.PUT_LINE('===== B3 fn_calculate_tax =====');
    show('tax(600000)  -> 0%',            fn_calculate_tax(600000));    -- 0
    show('tax(720000)  -> boundary',      fn_calculate_tax(720000));    -- 0
    show('tax(1000000) -> 20% band',      fn_calculate_tax(1000000));   -- 56000
    show('tax(1200000) -> boundary',      fn_calculate_tax(1200000));   -- 96000
    show('tax(2000000) -> 30% band',      fn_calculate_tax(2000000));   -- 336000
    BEGIN
        show('tax(-5)', fn_calculate_tax(-5));
    EXCEPTION WHEN OTHERS THEN
        show('tax(-5)', 'ERROR: ' || SQLERRM);                          -- ORA-20003
    END;

    DBMS_OUTPUT.PUT_LINE('===== B4 fn_dept_name =====');
    show('dept 10',   fn_dept_name(10));
    show('dept 30',   fn_dept_name(30));
    show('dept 99',   fn_dept_name(99));      -- Unknown
    show('dept NULL', fn_dept_name(NULL));    -- No Department
END;
/
