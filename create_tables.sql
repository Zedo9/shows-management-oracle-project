CREATE TABLE lieu(
	id_lieu INTEGER PRIMARY KEY,
	nom_lieu VARCHAR2 (30) NOT NULL,
	adresse VARCHAR2 (100) NOT NULL,
	capacite NUMBER NOT NULL
);

CREATE TABLE artiste(
	id_art INTEGER PRIMARY KEY,
	nom_art VARCHAR2 (30) NOT NULL,
	prenom_art VARCHAR2 (30) NOT NULL,
	specialite VARCHAR2 (10) NOT NULL
);

CREATE TABLE spectacle (
	id_spec INTEGER PRIMARY KEY,
	titre VARCHAR2 (40) NOT NULL,
	date_s DATE NOT NULL,
	h_debut NUMBER(4,2) NOT NULL,
	duree_s NUMBER(4,2) NOT NULL,
	nbr_spectateur INTEGER NOT NULL,
	id_lieu INTEGER
);

CREATE TABLE rubrique(
	id_rub INTEGER PRIMARY KEY,
	id_spec INTEGER NOT NULL,
	id_art INTEGER NOT NULL,
	h_debut_r NUMBER(4,2) NOT NULL,
	duree_rub NUMBER(4,2) NOT NULL,
	type VARCHAR2(10)
);

CREATE TABLE billet(
	id_billet INTEGER PRIMARY KEY,
	categorie VARCHAR2(10),
	prix NUMBER(5,2) NOT NULL,
	id_spec INTEGER NOT NULL ,
	vendu VARCHAR(3) NOT NULL
);