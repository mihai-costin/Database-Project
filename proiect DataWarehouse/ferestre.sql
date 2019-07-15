-- 2 cereri complexe care sa utilizeze conceptul de fereastra  
-- cat s-a vandut in fiecare zi din 2018
SELECT LIV.LIVID AS LIVID, LIV.DATA AS "DATA", VANZ.VALOAREA AS VALOARE, 
SUM(VANZ.VALOAREA) OVER (PARTITION BY DATA ORDER BY LIV.LIVID
                                   ROWS UNBOUNDED PRECEDING) AS TOTAL
FROM LIVRARI LIV, VANZARI VANZ
WHERE LIV.LIVID = VANZ.LIVID AND LIV.DATA >= to_date('01-01-2018','dd-mm-yyyy')
AND LIV.DATA <= to_date('31-12-2018','dd-mm-yyyy');


-- determinarea datei din 2018 in care s-au vandut cele mai multe publicati
SELECT DATA FROM  
(SELECT LIVID, DATA, TOTALLIV AS LIVRATE, 
SUM(TOTALLIV) OVER (PARTITION BY DATA) AS TOTAL_LIV 
FROM LIVRARI LIV WHERE DATA >= to_date('01-01-2018','dd-mm-yyyy')
AND DATA <= to_date('31-12-2018','dd-mm-yyyy')) WHERE ROWNUM <= 1 ORDER BY LIVID DESC;

SELECT LIVID, DATA, TOTALLIV AS LIVRATE, 
SUM(TOTALLIV) OVER (PARTITION BY DATA) AS TOTAL_LIV 
FROM LIVRARI LIV WHERE DATA >= to_date('01-01-2018','dd-mm-yyyy')
AND DATA <= to_date('31-12-2018','dd-mm-yyyy');

COMMIT;
