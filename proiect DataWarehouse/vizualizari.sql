-- crearea unei vizualizari materializare care sa retine cat s-a incasat pentru 
-- fiecare publicatie imparte

CREATE MATERIALIZED VIEW VANZ_PUB 
BUILD IMMEDIATE
REFRESH COMPLETE
ON DEMAND 
ENABLE QUERY REWRITE
AS SELECT LIVID, SUM(VALOAREA) AS "VALOARE" FROM VANZARI GROUP BY LIVID;

SELECT * FROM VANZ_PUB;

-- profitul total
SELECT SUM(VALOARE) AS TOTAL FROM VANZ_PUB;

ANALYZE TABLE VANZ_PUB COMPUTE STATISTICS;

EXPLAIN PLAN SET STATEMENT_ID ='view_1' FOR 
SELECT SUM(VALOARE) AS TOTAL FROM VANZ_PUB; 

SELECT plan_table_output  FROM 
table(dbms_xplan.display('plan_table','view_1','serial'));