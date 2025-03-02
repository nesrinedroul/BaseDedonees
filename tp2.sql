create table TableErreurs(
    adresse ROWID,
    utilisateur VARCHAR2(30),
    nomTable VARCHAR2(30),
    nomContrainte VARCHAR2(30)
);
create table fournisseur1 (nf integer,
                          nomf varchar (25),
                          statut varchar (25),
                          ville varchar (15),
                          email varchar (50),
CONSTRAINT pk_fournisseur PRIMARY KEY (nf),
CONSTRAINT uk_fournisseur UNIQUE (email),
CONSTRAINT ck_fournisseur check (email like '%@%' ));

alter table fournisseur1 disable constraint ck_fournisseur;
select constraint_name, constraint_type, status from user_constraints where table_name = 'FOURNISSEUR1';
insert into fournisseur1 values (2, 'au bon siege', 'sous tirant', 'Limoges','au_bon_siegegmail.com');
select rowid ,nf,email from fournisseur1;
select * from TableErreurs;
delete from fournisseur1 where rowid in ( select adresse from TableErreurs);
alter table fournisseur1 enable constraint ck_fournisseur exceptions into TableErreurs;
alter table fournisseur1 enable constraint ck_fournisseur;
insert into fournisseur1 values (2, 'au bon siege', 'sous tirant', 'Limoges','au_bon_siegegmail.com');