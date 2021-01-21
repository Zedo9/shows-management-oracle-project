CREATE OR REPLACE PACKAGE gest_spec IS
    CURSOR c_spec_id(id INTEGER) RETURN SPECTACLE%ROWTYPE;
    CURSOR c_spec_titre(v_titre SPECTACLE.TITRE%TYPE) RETURN SPECTACLE%ROWTYPE;
    CURSOR c_rub(id_s INTEGER, nom_a ARTISTE.NOM_ART%TYPE) RETURN RUBRIQUE%ROWTYPE;


    FUNCTION get_spec_by_id(id INTEGER) RETURN SPECTACLE%ROWTYPE;
    PROCEDURE annuler_spec(id INTEGER);
    PROCEDURE supp_rub(id INTEGER);
    PROCEDURE modif_rub(
        id INTEGER,
        id_a INTEGER, 
        du RUBRIQUE.DUREE_RUB%TYPE, 
        h_deb RUBRIQUE.H_DEBUT_R%TYPE
    );
    PROCEDURE ajout_rub(
        id_s RUBRIQUE.ID_SPEC%TYPE,
        id_a RUBRIQUE.ID_ART%TYPE,
        h_d_r RUBRIQUE.H_DEBUT_R%TYPE,
        du_r RUBRIQUE.DUREE_RUB%TYPE,
        t RUBRIQUE.TYPE%TYPE
    );
    PROCEDURE modif_spec(
        id_s INTEGER,
        t_s SPECTACLE.TITRE%TYPE,
        da_s SPECTACLE.DATE_S%TYPE,
        h_d_s SPECTACLE.H_DEBUT%TYPE,
        du_s SPECTACLE.DUREE_S%TYPE,
        n_s SPECTACLE.NBR_SPECTATEUR%TYPE,
        li_s SPECTACLE.ID_LIEU%TYPE
    );
    PROCEDURE ajout_spec(
        t_s SPECTACLE.TITRE%TYPE,
        da_s SPECTACLE.DATE_S%TYPE,
        h_d_s SPECTACLE.H_DEBUT%TYPE,
        du_s SPECTACLE.DUREE_S%TYPE,
        n_s SPECTACLE.NBR_SPECTATEUR%TYPE,
        li_s SPECTACLE.ID_LIEU%TYPE
    );
END gest_spec;
/

CREATE OR REPLACE PACKAGE BODY gest_spec IS
    CURSOR c_spec_id(id INTEGER) RETURN SPECTACLE%ROWTYPE IS
    SELECT * FROM SPECTACLE WHERE ID_SPEC = id;

    CURSOR c_spec_titre(v_titre SPECTACLE.TITRE%TYPE) RETURN SPECTACLE%ROWTYPE IS
    SELECT * FROM SPECTACLE WHERE UPPER(TITRE) = UPPER(v_titre);

    CURSOR c_rub(id_s INTEGER, nom_a ARTISTE.NOM_ART%TYPE) RETURN RUBRIQUE%ROWTYPE IS
    SELECT ru.id_rub, ru.id_spec, ru.id_art, ru.h_debut_r, ru.duree_rub, ru.type 
    FROM RUBRIQUE ru, ARTISTE ar
    WHERE ((ru.id_art = ar.id_art) AND (ru.ID_SPEC = id_s OR UPPER(NOM_ART) LIKE UPPER(nom_a))); 
    
    FUNCTION get_spec_by_id(id INTEGER) RETURN SPECTACLE%ROWTYPE IS
        res SPECTACLE%ROWTYPE;
        BEGIN
            OPEN c_spec_id(id);
            FETCH c_spec_id INTO res;
            CLOSE c_spec_id;
            RETURN res;
    END get_spec_by_id;

    PROCEDURE annuler_spec(id INTEGER) IS 
        BEGIN
            UPDATE SPECTACLE
            SET DATE_S = NULL
            WHERE ID_SPEC = id;
            COMMIT;
    END annuler_spec;

    PROCEDURE supp_rub(id INTEGER) IS
        BEGIN
            DELETE FROM RUBRIQUE
            WHERE ID_RUB = id;
            COMMIT;
    END supp_rub;

    PROCEDURE modif_rub(id INTEGER, id_a INTEGER, du RUBRIQUE.DUREE_RUB%TYPE, h_deb RUBRIQUE.H_DEBUT_R%TYPE) IS
        BEGIN
            IF id_a IS NOT NUll THEN
                UPDATE RUBRIQUE
                SET ID_ART = id_a 
                WHERE ID_RUB = id;
            END IF;

            IF du IS NOT NUll THEN
                UPDATE RUBRIQUE
                SET DUREE_RUB = du 
                WHERE ID_RUB = id;
            END IF;

            IF h_deb IS NOT NUll THEN
                UPDATE RUBRIQUE
                SET H_DEBUT_R = h_deb
                WHERE ID_RUB = id;
            END IF;
        COMMIT;
    END modif_rub;

    PROCEDURE ajout_rub(
        id_s RUBRIQUE.ID_SPEC%TYPE,
        id_a RUBRIQUE.ID_ART%TYPE,
        h_d_r RUBRIQUE.H_DEBUT_R%TYPE,
        du_r RUBRIQUE.DUREE_RUB%TYPE,
        t RUBRIQUE.TYPE%TYPE
    ) IS
        id INTEGER;
        BEGIN
            id := seq_rub.nextval;
            INSERT INTO RUBRIQUE
            VALUES (id,id_s,id_a,h_d_r,du_r,t);
    END ajout_rub;

    PROCEDURE modif_spec(
        id_s INTEGER,
        t_s SPECTACLE.TITRE%TYPE,
        da_s SPECTACLE.DATE_S%TYPE,
        h_d_s SPECTACLE.H_DEBUT%TYPE,
        du_s SPECTACLE.DUREE_S%TYPE,
        n_s SPECTACLE.NBR_SPECTATEUR%TYPE,
        li_s SPECTACLE.ID_LIEU%TYPE
    ) IS
        BEGIN
            IF t_s IS NOT NUll THEN
                UPDATE SPECTACLE
                SET TITRE = t_s 
                WHERE ID_SPEC = id_s;
            END IF;

            IF du_s IS NOT NUll THEN
                UPDATE SPECTACLE
                SET DUREE_S = du_s 
                WHERE ID_SPEC = id_s;
            END IF;

            IF h_d_s IS NOT NUll THEN
                UPDATE SPECTACLE
                SET H_DEBUT = h_d_s 
                WHERE ID_SPEC = id_s;
            END IF;

            IF da_s IS NOT NUll THEN
                UPDATE SPECTACLE
                SET DATE_S = da_s 
                WHERE ID_SPEC = id_s;
            END IF;

            IF n_s IS NOT NUll THEN
                UPDATE SPECTACLE
                SET NBR_SPECTATEUR = n_s 
                WHERE ID_SPEC = id_s;
            END IF;

            IF li_s IS NOT NUll THEN
                UPDATE SPECTACLE
                SET ID_LIEU = li_s 
                WHERE ID_SPEC = id_s;
            END IF;
            commit;
    END modif_spec;

    PROCEDURE ajout_spec(
        t_s SPECTACLE.TITRE%TYPE,
        da_s SPECTACLE.DATE_S%TYPE,
        h_d_s SPECTACLE.H_DEBUT%TYPE,
        du_s SPECTACLE.DUREE_S%TYPE,
        n_s SPECTACLE.NBR_SPECTATEUR%TYPE,
        li_s SPECTACLE.ID_LIEU%TYPE
    ) IS
        BEGIN
            INSERT INTO SPECTACLE
            VALUES(seq_spec.nextval,t_s,da_s,h_d_s,
            du_s,n_s,li_s);
    END ajout_spec;

END gest_spec;
/