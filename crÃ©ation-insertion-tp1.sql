--table usine1
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
