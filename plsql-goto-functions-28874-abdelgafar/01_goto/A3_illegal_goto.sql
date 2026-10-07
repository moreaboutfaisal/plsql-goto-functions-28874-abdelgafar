-- =====================================================
-- A3 - Illegal GOTO and the Fix
-- PL/SQL does NOT allow:
--   1) jumping INTO an IF / LOOP / CASE / nested block
--   2) jumping from an exception handler back into the block body
--   3) jumping to a label that does not exist or is not in scope
-- It DOES allow jumping OUT of an IF / loop to a label in an enclosing block.
-- =====================================================
SET SERVEROUTPUT ON

-- ---------- PART 1: ILLEGAL (this block FAILS to compile) ----------
-- Expected error:  PLS-00375: illegal GOTO statement; this GOTO cannot branch to label 'INSIDE_IF'
DECLARE
    v_n NUMBER := 5;
BEGIN
    GOTO inside_if;                      -- ILLEGAL: jumps INTO the IF block
    IF v_n > 0 THEN
        <<inside_if>>
        DBMS_OUTPUT.PUT_LINE('Inside the IF');
    END IF;
END;
/

-- ---------- PART 2: THE FIX (compiles and runs) ----------
-- The label now lives in the enclosing block, and the GOTO jumps OUT of the IF.
DECLARE
    v_n NUMBER := 5;
BEGIN
    IF v_n > 0 THEN
        GOTO show_positive;              -- LEGAL: jumping out of an IF
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_n || ' is not positive');
    GOTO finish;

    <<show_positive>>
    DBMS_OUTPUT.PUT_LINE(v_n || ' is positive');

    <<finish>>
    DBMS_OUTPUT.PUT_LINE('Program finished');
END;
/
