# C2 - Reflection

## What I learned about GOTO
GOTO jumps to a label written as `<<label_name>>`. A label must be followed by an executable statement, so I used `NULL;` when there was nothing else to do (for example `<<next_number>> NULL;` at the end of a loop). In A1 and A2 I used GOTO to send each case to its own block of code. PL/SQL lets me jump *out* of an IF or a loop to a label in the enclosing block, but it does not let me jump *into* an IF, a loop or a nested block, and it does not let me jump from an exception handler back into the block. In A3 I tested this on purpose: the illegal version failed with `PLS-00375: illegal GOTO statement`, and the fixed version worked once the label was outside the IF.

## GOTO versus structured code
In A4 I rewrote A1 and A2 without GOTO, using `IF/ELSIF`, `CASE` and `CONTINUE`. The results were exactly the same, but the code was shorter and easier to read, because the flow goes from top to bottom instead of jumping between labels. This is why GOTO is usually avoided. Still, in C1 I used GOTO as a single exit point: every failed check sets an error message and jumps to one label that returns `INVALID: <reason>`. That avoided repeating the same RETURN statement many times.

## What I learned about functions
A function must `RETURN` a value, so it can be used inside expressions and inside SQL statements (`SELECT`, `WHERE`, `ORDER BY`), as I did in B5. This lets me reuse logic such as the annual salary, the tax and the department name instead of repeating formulas in every query. Functions called from SQL should not do DML or `COMMIT`. `CREATE OR REPLACE` lets me fix a function without dropping it, and `SHOW ERRORS` shows compilation problems. I also used `DETERMINISTIC` for B1 and B3 because the same input always gives the same output.

## Exception handling
I used `NO_DATA_FOUND` when a lookup finds nothing (B4 returns `Unknown`, C1 returns `Employee 999 not found`) and `RAISE_APPLICATION_ERROR` for invalid values (`ORA-20001` in B1 and `ORA-20003` in B3). In `test_functions.sql` I caught these errors with a nested block to show that they are raised correctly. C1 also has a `WHEN OTHERS` handler so it always returns a readable message instead of crashing.

## Challenges
- **A3:** I had to understand why the first block fails. The label is inside the IF block, and a GOTO cannot enter a block from outside.
- **Order of creation:** C1 calls B1, B3 and B4, so those functions must be created first.
- **Screenshots:** The output of A2, A4 and B5 was long, so I had to resize the panes in SQL Developer so the code and the output were visible together.
- **B5 output:** The first version of the query wrapped each row over several lines because the columns were too wide. I fixed it with `COLUMN ... FORMAT` so every employee fits on one line.

## What I would improve
- Store the tax brackets in a table instead of fixed numbers inside B3.
- Write a procedure that runs the payroll validation for a whole department and reports a summary.
- Add a foreign key from `employees.dept_id` to `departments` once the test data no longer needs an invalid department.
