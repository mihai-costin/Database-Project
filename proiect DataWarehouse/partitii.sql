-- partitionarea tabelului livrari prin ordonare in functie de luni

CREATE TABLE LIVRARI_ORD PARTITION BY RANGE(DATA)
(  PARTITION LIVRARI_2016 VALUES LESS THAN(to_date('01-01-2017','dd-mm-yyyy')),
   PARTITION LIVRARI_2017 VALUES LESS THAN(to_date('01-01-2018','dd-mm-yyyy')),
   PARTITION LIVRARI_2018 VALUES LESS THAN(to_date('01-01-2019','dd-mm-yyyy'))
) AS SELECT * FROM LIVRARI;

SELECT * FROM LIVRARI_ORD;

-- numarul de publicatii livrate anual
SELECT TO_CHAR(DATA, 'YYYY') AS AN, COUNT(*) AS "NR.VANDUTE" FROM LIVRARI_ORD 
GROUP BY TO_CHAR(DATA,'YYYY');

ANALYZE TABLE LIVRARI_ORD COMPUTE STATISTICS;
EXPLAIN PLAN SET STATEMENT_ID='part_1' FOR 
SELECT TO_CHAR(DATA, 'YYYY') AS AN, COUNT(*) AS "NR.VANDUTE" FROM LIVRARI_ORD 
GROUP BY TO_CHAR(DATA,'YYYY');

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table','part_1','serial'));

-- partitionare prin hash a tabelului vanzari
CREATE TABLE VANZARI_HASH PARTITION BY HASH(PUBID) PARTITIONS 5
AS SELECT * FROM VANZARI;

SELECT * FROM VANZARI_HASH;

-- care este suma incasata in total pentru publicatia cu numarul 25
SELECT SUM(VALOAREA) AS "VALOARE INCASATA" FROM VANZARI_HASH WHERE PUBID = 25;

ANALYZE TABLE VANZARI_HASH COMPUTE STATISTICS;
EXPLAIN PLAN SET STATEMENT_ID='part_2' FOR 
SELECT SUM(VALOAREA) AS "VALOARE INCASATA" FROM VANZARI_HASH WHERE PUBID = 25;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY('plan_table','part_2','serial'));

COMMIT;
