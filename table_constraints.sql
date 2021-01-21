-- lieu
ALTER TABLE lieu
ADD CONSTRAINT cap_lim 
CHECK (capacite BETWEEN 100 AND 2000);

-- Lieu suppression logique
ALTER TABLE lieu
ADD is_deleted NUMBER(1) DEFAULT 0 NOT NULL;


-- artiste
ALTER TABLE artiste
ADD CONSTRAINT chk_spec 
CHECK (specialite IN ('danseur','acteur','musicien','magicien','imitateur','humoriste','chanteur'));

-- spectacle
ALTER TABLE spectacle
ADD (
    CONSTRAINT chk_spect_durees CHECK (DUREE_S BETWEEN 1 AND 4),
    CONSTRAINT fk_spect_lieu FOREIGN KEY(id_lieu) REFERENCES lieu(id_lieu)
);

-- rubrique
ALTER TABLE rubrique
ADD (
    CONSTRAINT fk_rub_spect FOREIGN KEY(id_spec) REFERENCES spectacle(id_spec) ON DELETE CASCADE,
    CONSTRAINT fk_rub_art FOREIGN KEY(id_art) REFERENCES artiste(id_art) ON DELETE CASCADE ,
    CONSTRAINT chk_type CHECK (type IN ('comedie','theatre','dance','imitation','magie','musique','chant'))
);

-- billet
ALTER TABLE billet
ADD (
    CONSTRAINT chk_biller_categ CHECK (categorie in ('gold','silver','normale')),
    CONSTRAINT chk_billet_PRIX CHECK(prix BETWEEN 10 AND 300),
    CONSTRAINT fk_billet_spec FOREIGN KEY (id_spec)REFERENCES spectacle(id_spec),
    CONSTRAINT chk_billet_vendu CHECK(vendu IN ('oui','non'))
);
