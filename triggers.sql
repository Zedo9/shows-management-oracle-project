-- Spectacles
CREATE OR REPLACE TRIGGER chk_spec_nbr
BEFORE INSERT OR UPDATE of NBR_SPECTATEUR ON SPECTACLE
FOR EACH ROW
DECLARE
    max_cap NUMBER;
    id_l INTEGER;
BEGIN
    IF UPDATING THEN
        id_l := :old.id_lieu;
    END IF;

    IF inserting THEN
        id_l := :new.id_lieu;
    END IF;

    SELECT CAPACITE
    INTO max_cap
    FROM LIEU
    WHERE ID_LIEU = id_l;

    IF :NEW.NBR_SPECTATEUR > max_cap THEN
        RAISE_APPLICATION_ERROR(-20001,'Espace insuffisant pour ce nombre de spectateurs');
        
    END IF;
END;
/
CREATE OR REPLACE TRIGGER chk_spec_date
BEFORE INSERT OR UPDATE of DATE_S ON SPECTACLE
FOR EACH ROW
DECLARE
    curr_date DATE;
BEGIN
    curr_date := SYSDATE();
    IF :NEW.DATE_S <= curr_date THEN
        RAISE_APPLICATION_ERROR(-20001,'verifiez la date');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER upd_rub_spec
AFTER UPDATE of H_DEBUT ON SPECTACLE
FOR EACH ROW
DECLARE
    diff NUMBER(4,2);
BEGIN
    diff := :new.h_debut - :old.h_debut;
    UPDATE RUBRIQUE
    SET H_DEBUT_R = H_DEBUT_R + diff
    WHERE ID_SPEC = :new.id_spec; 
END;
/
-- Rubriques
CREATE OR REPLACE TRIGGER chk_rub_nbr
BEFORE INSERT ON RUBRIQUE
FOR EACH ROW
DECLARE
    nbr INTEGER;
BEGIN
    SELECT count(*)
    INTO nbr
    FROM RUBRIQUE
    WHERE id_art = :new.id_art;
    IF nbr > 2 THEN
        RAISE_APPLICATION_ERROR(-20001,'Vous avez déja 3 rubriques pour ce spectacle');
    END IF;
END;
/
CREATE OR REPLACE TRIGGER chk_rub_durr
BEFORE INSERT OR UPDATE of DUREE_RUB ON RUBRIQUE
FOR EACH ROW
DECLARE
    curr_dur_spec NUMBER(4,2);
    id_sp INTEGER;
    spec SPECTACLE%ROWTYPE;
BEGIN

    IF UPDATING THEN
        id_sp := :old.id_spec;
    END IF;

    IF inserting THEN
        id_sp := :new.id_spec;
    END IF;

    SELECT sum(DUREE_RUB)
    INTO curr_dur_spec
    FROM RUBRIQUE
    WHERE ID_SPEC = id_sp;

    curr_dur_spec := curr_dur_spec + :new.duree_rub;

    spec := GEST_SPEC.get_spec_by_id(id_sp);
    
    IF spec.duree_s < curr_dur_spec THEN
        RAISE_APPLICATION_ERROR(-20001,'La durée des rubriques dépasse la duree du spectacle');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER chk_rub_art
BEFORE INSERT OR UPDATE of ID_ART ON RUBRIQUE
FOR EACH ROW
DECLARE
    id_sp INTEGER;
    nb_rub_art INTEGER;
    specialite_art VARCHAR2(10);
    h_deb NUMBER(4,2);
    typ_rub VARCHAR2(10);
    typ_art VARCHAR2(10);
BEGIN
    IF UPDATING THEN
        id_sp := :old.id_spec;
        h_deb := :old.h_debut_r;
        typ_rub := :old.type;
    END IF;

    IF inserting THEN
        id_sp := :new.id_spec;
        h_deb := :new.h_debut_r;
        typ_rub := :new.type;
    END IF;

    SELECT count(*)
    INTO nb_rub_art
    FROM RUBRIQUE
    WHERE ID_ART = :new.id_art AND H_DEBUT_R=h_deb;

    IF nb_rub_art > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,'cet artiste n est pas disponible pour cette rubrique');
    END IF;

    SELECT SPECIALITE 
    INTO typ_art
    from ARTISTE
    WHERE ID_ART = :new.id_art;
    
    if UPPER(:new.type) <> UPPER(typ_art) THEN
        RAISE_APPLICATION_ERROR(-20001,'Cet artiste n est pas adapte pour la rubrique');
    END IF;
    
END;
/
--lieux
CREATE OR REPLACE TRIGGER supp_lieu
BEFORE DELETE ON LIEU
FOR EACH ROW
DECLARE
    nb_spect INTEGER;
BEGIN
    SELECT count(*)
    INTO nb_spect
    FROM SPECTACLE
    WHERE ID_LIEU = :old.id_lieu;

    IF nb_spect > 0 THEN
        UPDATE LIEU
        SET is_deleted = 1
        WHERE ID_LIEU = :old.id_lieu;
        RAISE_APPLICATION_ERROR(-20000,'Une supression logique du lieu a été faite');
    END IF;
END;
/