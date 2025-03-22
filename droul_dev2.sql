--qst1
connect ing/psw ;
--qst2
create user USERFOUR identified by psw1 default tablespace
Livraison_TBS temporary tablespace Livraison_TempTBS;

connect system/29112004;
desc dba_users;
select username,created from dba_users where username='USERFOUR';
connect userfour/psw1;
--qst3 -- DOESNT HAVE PRIVILEGES TO DO SO
connect ing/psw;
grant create session to userfour;
CONNECT system/psw;
desc dba_sys_privs;
select privilege , admin_option from dba_sys_privs where grantee='USERFOUR';
connect userfour/psw1;
select privilege , admin_option from user_sys_privs;
--qst4
connect ing/psw;
grant create table , create view , create user to USERFOUR; --
create table test (a integer, b char(1));
alter user USERFOUR quota unlimited on LIVRAISON_TBS;
create table test (a integer, b char(1));
select table_name from tabs;
insert into test values (1, 'b');
select * from test;
select object_name, object_type from user_objects;
create view view1 as select a from test;
--qst 5
grant select on fournisseur1 to userfour;
connect userfour/psw1;
select * from ing.fournisseur1;
--qst6
connect ing/psw;
-- creation des tables

CREATE TABLE usine1 (NU int,                                           
                   NomU varchar(15),                                           
                   Ville varchar(15),    
CONSTRAINT pk_usine1 PRIMARY KEY (NU));

--table produit1
create table produit1 ( np integer,
                       nomp varchar (20),
                       couleur varchar (10) ,
                       poids real ,
CONSTRAINT pk_produit1 PRIMARY KEY (np),
CONSTRAINT ck_produit1 check (poids>0) 
) ;



--table fourisseur1


--table livraison1
create table livraison1 (np integer ,
                        nu integer ,
                        nf integer ,
                        quantite integer,
Constraint pk_livraison1 primary key (np,nu ,nf),
Constraint fk_livraison1_prod foreign key (np) references produit1 (np) on delete cascade,
Constraint fk_livraison1_usin foreign key (nu) references usine1 (nu) on delete cascade,
Constraint fk_livraison1_four foreign key (nf) references fournisseur1 (nf) on delete cascade,
Constraint ck_livraison1 check (quantite>0) 
); 


--Insertion

insert into usine1 values ( 1 ,'Citroen','Paris') ;
insert into usine1 values ( 2 ,'Peugeot','Sochaux') ;
insert into usine1 values ( 3 ,'Citroen','Sochaux') ;
insert into usine1 values ( 4 ,'Renault','Paris') ;
insert into usine1 values ( 5 ,'Toyota','Lyon') ;

insert into produit1 values ( 1 ,'Plaquette','Noir', 0.257 ) ;
insert into produit1 values ( 2 ,'Siege','Rouge', 15.230 ) ;
insert into produit1 values ( 3 ,'Siege','Vert', 15.230 ) ;
insert into produit1 values ( 4 ,'Parebrise', null , 11.900 ) ;
insert into produit1 values ( 5 ,'Retroviseur','Vert', 1.020 ) ;

insert into fournisseur1 values
( 1 ,'Monroe','Producteur','Lyon','monroe@gmail.com') ;
insert into fournisseur1 values
( 2 ,'Au bon siege','Sous traitant','Limoges','au_bon_siege@gmail.com') ;
insert into fournisseur1 values
( 3 ,'Saint Gobain','Producteur','Paris','saint_goubain@gmail.com') ;

insert into livraison1 values ( 3 , 1 , 2 ,60 ) ;
insert into livraison1 values ( 1 , 2 , 3 , 2500 ) ;
insert into livraison1 values ( 1 , 3 , 3 , 3000 ) ;
insert into livraison1 values ( 2 , 2 , 3 , 120 ) ;
insert into livraison1 values ( 3 , 1 , 1 , 49 ) ;
insert into livraison1 values ( 3 , 2 , 1 , 45 ) ;
insert into livraison1 values ( 3 , 3 , 1 , 78 ) ;
insert into livraison1 values ( 2 , 4 , 2 , 52 ) ;
insert into livraison1 values ( 2 , 1 , 1 , 250 ) ;
insert into livraison1 values ( 2 , 1 , 3 , 250 ) ;

grant delete on produit1 to userfour;
grant select , delete on livraison1 to userfour;
connect userfour/psw1;
delete from produit1 where np not in (select np from livraison1);
--qst7
connect ing/psw;
grant index on fournisseur1 to userfour;
connect userfour/psw1;
create index ind_nf on ing.fournisseur1 (nomf);
--qst8
-- Script SQL pour la création du profil USERFOUR_Profil
-- Ce script utilise la commande CREATE PROFILE pour définir un profil avec 
-- des limites spécifiques pour les ressources et la sécurité du mot de passe

CREATE PROFILE USERFOUR_Profil LIMIT
  SESSIONS_PER_USER             4        
  CONNECT_TIME                  70      
  IDLE_TIME                     20      
  CPU_PER_CALL                  30000   
  LOGICAL_READS_PER_CALL        1300     
  PRIVATE_SGA                   30K     
  FAILED_LOGIN_ATTEMPTS         3        
  PASSWORD_LIFE_TIME            60      
  PASSWORD_REUSE_TIME           40      
  PASSWORD_LOCK_TIME            1       
  PASSWORD_GRACE_TIME           7;   
  alter user userfour profile userfour_profil;
  connect system/29112004;
SELECT username, profile 
FROM dba_users 
WHERE username = 'USERFOUR';
--qst9
connect ing/psw;
CREATE role GESTIONNAIRE_DES_LIVRAISONS ;
grant select on fournisseur1 to GESTIONNAIRE_DES_LIVRAISONS;
grant select on produit1 to GESTIONNAIRE_DES_LIVRAISONS;
grant select on usine1 to GESTIONNAIRE_DES_LIVRAISONS;;
grant delete ,select, insert , update on livraison1 to GESTIONNAIRE_DES_LIVRAISONS;
grant GESTIONNAIRE_DES_LIVRAISONS to userfour;
--verification
SELECT privilege
FROM role_sys_privs
WHERE role = 'GESTIONNAIRE_DES_LIVRAISONS';

-- Vérifier tous les privilèges sur objets obtenus par l'utilisateur via ce rôle
SELECT owner, table_name, privilege
FROM role_tab_privs
WHERE role = 'GESTIONNAIRE_DES_LIVRAISONS';
connect userfour/psw1;
SELECT * FROM user_tab_privs
WHERE grantee = 'USERFOUR';
connect system/29112004;
select * from dict;
select comments from dict where table_name='USER_USERS';
select comments from dict where table_name='DBA_USERS';
--partie data 
select COMMENTS
from DICT
where TABLE_NAME = 'ALL_TAB_COLUMNS';
----USER_USERS
--structure
describe USER_USERS;
--description
select COMMENTS
from DICT
where TABLE_NAME = 'USER_USERS';
-- ALL_CONSTRAINTS
--structure
 describe ALL_CONSTRAINTS;
 --description
 select COMMENTS
from DICT
where TABLE_NAME = 'ALL_CONSTRAINTS';
--USER_USERS
--structure
describe USER_TAB_PRIVS;
--description
select COMMENTS
from DICT
where TABLE_NAME = 'USER_TAB_PRIVS';
--Trouver le nom d’utilisateur avec lequel vous êtes connecté (sans utiliser show user, en utilisant le dictionnaire)?
select USERNAME 
from USER_USERS;
--15 
connect ing/psw;
select table_name from user_tables;
connect system/29112004;
select table_name from dba_tables where owner='ING';
--16
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, COLUMN_ID
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME IN ('PRODUIT', 'LIVRAISON');
--17
SELECT UC.CONSTRAINT_NAME, UC.TABLE_NAME, UCC.COLUMN_NAME, UC.R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.CONSTRAINT_TYPE = 'R' 
AND UC.TABLE_NAME = 'PRODUIT';
--18
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME, STATUS
FROM USER_CONSTRAINTS;
--19
SELECT 
GRANT CONNECT TO USERFOUR;
GRANT SELECT ON FOURNISSEUR TO USERFOUR;

SELECT * FROM USER_TAB_PRIVS WHERE GRANTEE = 'USERFOUR';
--21
CREATE ROLE ROLE_GESTION;
GRANT SELECT ON PRODUIT TO ROLE_GESTION;
GRANT UPDATE ON FOURNISSEUR TO ROLE_GESTION;
--22
GRANT ROLE_GESTION TO USERFOUR;
SELECT * FROM USER_ROLE_PRIVS WHERE GRANTEE = 'USERFOUR';
SELECT OBJECT_NAME, OBJECT_TYPE 
FROM USER_OBJECTS;
--23
SELECT OWNER 
FROM ALL_TAB_COLUMNS 
WHERE TABLE_NAME = 'FOURNISSEUR';
--24
SELECT INSTANCE_NAME, VERSION, STATUS 
FROM V$INSTANCE;
--25
SELECT NAME, OPEN_MODE 
FROM V$DATABASE;
--26
SELECT * FROM V$SGA;
SELECT NAME, BYTES 
FROM V$SGASTAT;
--27
SELECT MEMBER 
FROM V$LOGFILE;
--28
SELECT FILE_NAME, BLOCK_SIZE 
FROM V$DATAFILE;
--29
SELECT TABLESPACE_NAME, TS# 
FROM V$TABLESPACE;
--30
SELECT TABLESPACE_NAME, FILE_NAME 
FROM DBA_DATA_FILES;


