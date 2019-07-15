-- crearea unei dimesiuni referitoare la publicatii
-- ierarhia pubid - redactie - redactorSef
-- depedenta dintre atribute pubid - (nume, pret)

CREATE DIMENSION pub_dim
      LEVEL pub IS (PUBLICATII.PUBID)
      LEVEL red IS (REDACTII.REDID)
      LEVEL redSef IS (REDACTII.RedactorSef)
      HIERARCHY pub_rollup (
          pub CHILD OF
          red CHILD OF
          redSef
          JOIN KEY (PUBLICATII.NRRED)   
                    REFERENCES red
      )
      ATTRIBUTE pub DETERMINES (PUBLICATII.NUME, PUBLICATII.PRET);

DESC USER_DIMENSIONS;

SELECT DIMENSION_NAME, INVALID, COMPILE_STATE, REVISION 
FROM   USER_DIMENSIONS
WHERE  LOWER(DIMENSION_NAME) LIKE '%pub_dim';

-- validare
EXECUTE DBMS_DIMENSION.VALIDATE_DIMENSION(UPPER('pub_dim'),false,false,'id_1'); 

SELECT * 
FROM   dimension_exceptions
WHERE  statement_id = 'id_1';

COMMIT;