-- =====================================================
-- 00_setup/create_tables.sql
-- Creates the DEPARTMENTS and EMPLOYEES tables + sample data
-- Some rows are intentionally "bad" so the validator (C1) has something to catch
-- =====================================================
SET SERVEROUTPUT ON

BEGIN EXECUTE IMMEDIATE 'DROP TABLE employees PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE departments PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE departments (
    dept_id   NUMBER(4)     PRIMARY KEY,
    dept_name VARCHAR2(50)  NOT NULL
);

-- No FK on dept_id on purpose: lets us store an invalid dept (99) to test the validator
CREATE TABLE employees (
    emp_id         NUMBER(6)     PRIMARY KEY,
    first_name     VARCHAR2(30)  NOT NULL,
    last_name      VARCHAR2(30)  NOT NULL,
    monthly_salary NUMBER(12,2),
    hire_date      DATE,
    dept_id        NUMBER(4)
);

INSERT INTO departments VALUES (10, 'Human Resources');
INSERT INTO departments VALUES (20, 'Finance');
INSERT INTO departments VALUES (30, 'IT');
INSERT INTO departments VALUES (40, 'Marketing');

INSERT INTO employees VALUES (101, 'Alice',    'Uwase',       1200000, DATE '2015-03-15', 10);
INSERT INTO employees VALUES (102, 'Eric',     'Habimana',     850000, DATE '2018-07-01', 20);
INSERT INTO employees VALUES (103, 'Grace',    'Mukamana',     450000, DATE '2021-01-10', 30);
INSERT INTO employees VALUES (104, 'Jean',     'Nkurunziza',   300000, DATE '2023-09-01', 30);
INSERT INTO employees VALUES (105, 'Diane',    'Ingabire',    1500000, DATE '2012-05-20', 40);
INSERT INTO employees VALUES (106, 'Patrick',  'Niyonzima',    600000, DATE '2019-11-11', NULL);   -- no department
INSERT INTO employees VALUES (107, 'Claudine', 'Umutoni',       NULL,  DATE '2022-02-02', 20);     -- missing salary
INSERT INTO employees VALUES (108, 'Samuel',   'Mugisha',           0, DATE '2020-06-06', 10);     -- zero salary
INSERT INTO employees VALUES (109, 'Olivia',   'Kayitesi',     700000, DATE '2017-08-08', 99);     -- dept 99 does not exist
INSERT INTO employees VALUES (110, 'Kevin',    'Bizimana',     500000, DATE '2030-01-01', 30);     -- hire date in the future

COMMIT;

SELECT * FROM departments ORDER BY dept_id;
SELECT * FROM employees   ORDER BY emp_id;
