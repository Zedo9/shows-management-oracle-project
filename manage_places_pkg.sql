CREATE OR REPLACE PACKAGE gest_lieu IS
    CURSOR c_lieu_cap(cap NUMBER) RETURN LIEU%ROWTYPE;
    CURSOR c_lieu_ville(ville LIEU.ADRESSE%TYPE) RETURN LIEU%ROWTYPE;

    PROCEDURE supp_lieu(id INTEGER);

    PROCEDURE ajouter_lieu(
        nom LIEU.NOM_LIEU%TYPE,
        adr LIEU.ADRESSE%TYPE,
        cap LIEU.CAPACITE%TYPE
    );
    PROCEDURE modif_lieu_cap(id LIEU.ID_LIEU%TYPE, nouv_cap LIEU.CAPACITE%TYPE);
    PROCEDURE modif_lieu_nom(id LIEU.ID_LIEU%TYPE, nouv_nom LIEU.CAPACITE%TYPE);
    FUNCTION chercher_lieu_nom(nom LIEU.NOM_LIEU%TYPE) RETURN INTEGER;
END gest_lieu;
/

CREATE OR REPLACE PACKAGE BODY gest_lieu IS
    CURSOR c_lieu_cap(cap NUMBER) RETURN LIEU%ROWTYPE IS
    SELECT * FROM LIEU WHERE CAPACITE = cap;

    CURSOR c_lieu_ville(ville LIEU.ADRESSE%TYPE) RETURN LIEU%ROWTYPE IS
    SELECT * FROM LIEU WHERE UPPER(ville) IN UPPER(ADRESSE);

    PROCEDURE supp_lieu(id INTEGER) IS
        BEGIN
            DELETE 
            FROM LIEU
            WHERE ID_LIEU = id;
    END supp_lieu;

    PROCEDURE ajouter_lieu(
        nom LIEU.NOM_LIEU%TYPE,
        adr LIEU.ADRESSE%TYPE,
        cap LIEU.CAPACITE%TYPE
    ) IS 
            id LIEU.ID_LIEU%TYPE;    
        BEGIN
            SELECT max(ID_LIEU)
            INTO id
            FROM LIEU;
            id := id +1;
            DBMS_OUTPUT.PUT_LINE(id);
            INSERT INTO LIEU(ID_LIEU,NOM_LIEU,ADRESSE,CAPACITE) VALUES(id,nom,adr,cap);
            COMMIT;
    END ajouter_lieu;

    PROCEDURE modif_lieu_cap(id LIEU.ID_LIEU%TYPE, nouv_cap LIEU.CAPACITE%TYPE) IS  
        BEGIN
            UPDATE LIEU
            SET CAPACITE = nouv_cap
            WHERE ID_LIEU = id;
            COMMIT;
    END modif_lieu_cap;

    PROCEDURE modif_lieu_nom(id LIEU.ID_LIEU%TYPE, nouv_nom LIEU.CAPACITE%TYPE) IS  
        BEGIN
            UPDATE LIEU
            SET NOM_LIEU = nouv_nom
            WHERE ID_LIEU = id;
            COMMIT;
    END modif_lieu_nom;

    FUNCTION chercher_lieu_nom(nom LIEU.NOM_LIEU%TYPE) RETURN INTEGER IS
        id LIEU.ID_LIEU%TYPE;    
        BEGIN
            SELECT ID_LIEU
            INTO id
            FROM LIEU
            WHERE UPPER(nom) = UPPER(NOM_LIEU);
            RETURN id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RETURN 0;
    END chercher_lieu_nom;
END gest_lieu;
/

