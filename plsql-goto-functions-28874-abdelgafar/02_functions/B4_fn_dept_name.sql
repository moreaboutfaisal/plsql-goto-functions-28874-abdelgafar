-- =====================================================
-- B4 - fn_dept_name: returns the department name for a dept_id
-- NULL id -> 'No Department' ; id not found -> 'Unknown'
-- =====================================================
CREATE OR REPLACE FUNCTION fn_dept_name (
    p_dept_id IN NUMBER
) RETURN VARCHAR2
IS
    v_name departments.dept_name%TYPE;
BEGIN
    IF p_dept_id IS NULL THEN
        RETURN 'No Department';
    END IF;

    SELECT dept_name
    INTO   v_name
    FROM   departments
    WHERE  dept_id = p_dept_id;

    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown';
END fn_dept_name;
/
SHOW ERRORS FUNCTION fn_dept_name
