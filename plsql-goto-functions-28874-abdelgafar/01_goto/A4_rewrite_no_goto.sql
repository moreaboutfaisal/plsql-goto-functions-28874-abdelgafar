-- =====================================================
-- A4 - Rewrite A1 and A2 WITHOUT GOTO
-- Uses IF / ELSIF, CASE and CONTINUE instead of labels.
-- Same output as the GOTO versions, but easier to read.
-- =====================================================
SET SERVEROUTPUT ON

-- ---------- A1 rewritten ----------
DECLARE
    TYPE t_nums IS TABLE OF NUMBER;
    v_list   t_nums := t_nums(15, -4, 0, 8, -7);
    v_num    NUMBER;
    v_sign   VARCHAR2(10);
    v_parity VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- A1 without GOTO ---');
    FOR i IN 1 .. v_list.COUNT LOOP
        v_num := v_list(i);

        IF v_num = 0 THEN
            DBMS_OUTPUT.PUT_LINE(v_num || ' -> ZERO (neither positive nor negative)');
        ELSE
            v_sign   := CASE WHEN v_num > 0 THEN 'POSITIVE' ELSE 'NEGATIVE' END;
            v_parity := CASE WHEN MOD(v_num, 2) = 0 THEN 'EVEN' ELSE 'ODD' END;
            DBMS_OUTPUT.PUT_LINE(v_num || ' -> ' || v_sign || ' and ' || v_parity);
        END IF;
    END LOOP;
END;
/

-- ---------- A2 rewritten ----------
DECLARE
    v_pct NUMBER;
    v_new NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- A2 without GOTO ---');
    FOR r IN (SELECT emp_id, first_name, last_name, monthly_salary
              FROM   employees
              ORDER  BY emp_id) LOOP

        IF r.monthly_salary IS NULL OR r.monthly_salary <= 0 THEN
            DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                                 ': SKIPPED (invalid or missing salary)');
            CONTINUE;                  -- go to next employee (replaces GOTO skip/next)
        END IF;

        IF r.monthly_salary >= 1000000 THEN
            DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                                 ': ' || r.monthly_salary || ' -> no raise (already high)');
            CONTINUE;
        END IF;

        v_pct := CASE WHEN r.monthly_salary < 500000 THEN 10 ELSE 5 END;
        v_new := r.monthly_salary * (1 + v_pct / 100);
        DBMS_OUTPUT.PUT_LINE(r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                             ': ' || r.monthly_salary || ' -> ' || v_new ||
                             ' (' || v_pct || '% raise)');
    END LOOP;
END;
/
