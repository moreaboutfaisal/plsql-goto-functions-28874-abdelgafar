-- =====================================================
-- A1 - Number Classifier (uses GOTO)
-- Classifies each number as POSITIVE / NEGATIVE / ZERO and EVEN / ODD
-- =====================================================
SET SERVEROUTPUT ON

DECLARE
    TYPE t_nums IS TABLE OF NUMBER;
    v_list   t_nums := t_nums(15, -4, 0, 8, -7);
    v_num    NUMBER;
    v_sign   VARCHAR2(10);
    v_parity VARCHAR2(10);
BEGIN
    FOR i IN 1 .. v_list.COUNT LOOP
        v_num := v_list(i);

        -- Step 1: decide the sign and JUMP to the right label
        IF v_num > 0 THEN
            GOTO is_positive;
        ELSIF v_num < 0 THEN
            GOTO is_negative;
        ELSE
            GOTO is_zero;
        END IF;

        <<is_positive>>
        v_sign := 'POSITIVE';
        GOTO check_parity;

        <<is_negative>>
        v_sign := 'NEGATIVE';
        GOTO check_parity;

        <<is_zero>>
        DBMS_OUTPUT.PUT_LINE(v_num || ' -> ZERO (neither positive nor negative)');
        GOTO next_number;          -- skip the parity check for zero

        -- Step 2: even or odd
        <<check_parity>>
        IF MOD(v_num, 2) = 0 THEN
            v_parity := 'EVEN';
        ELSE
            v_parity := 'ODD';
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_num || ' -> ' || v_sign || ' and ' || v_parity);

        <<next_number>>
        NULL;                      -- a label must be followed by a statement
    END LOOP;
END;
/
