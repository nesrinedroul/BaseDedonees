--partie 1
-- first
ALTER TABLE Fournisseur
ADD Adresse VARCHAR(255);
--2
ALTER TABLE Fournisseur
DROP COLUMN Adresse;
--3
-- pour verifier la structure de la table
desc Fournisseur;
 -- les insertions
SELECT * FROM Fournisseur;
SELECT * FROM Produit;
-- 2eme partie
--1 
select * from usine;
--2
select NU , NomU from usine where Ville LIKE 'Sochaux';
--3
select distinct nf from
livraison where nu = 1 AND np = 3;
--les nom des fournisseurs
select nomF from fournisseur where nf in ( select nf from livraison where nu =1 and np =3);
--4
SELECT NP, NomProd
FROM Produit
WHERE Couleur IS NULL;
--5
SELECT DISTINCT NomU
FROM Usine
ORDER BY NomU ASC;


--
--
SELECT NomProd, Couleur
FROM Produit
WHERE NP IN (
    SELECT NP
    FROM Livraison
    WHERE nf = 2
);
SELECT NU
FROM Usine
WHERE NomU LIKE 'C%';
--7
SELECT NP
FROM Produit
WHERE NomProd LIKE '%S%';
--8 
SELECT DISTINCT Fournisseur.nf
FROM Livraison
JOIN Fournisseur ON Livraison.nf = Fournisseur.nf
WHERE Livraison.NU = 1 AND Livraison.NP = 3;
--9
SELECT DISTINCT Produit.NomProd, Produit.Couleur
FROM Livraison
JOIN Produit ON Livraison.NP = Produit.NP
WHERE Livraison.nf = 2;
--10
SELECT DISTINCT L.nf
FROM Livraison l
JOIN Produit p ON L.NP = P.NP
WHERE L.NU = 1 AND P.Couleur = 'rouge';
-- avec requete imbriquee
select distinct 
--11
SELECT DISTINCT NomF
FROM Livraison l , produit p , fournisseur f , usine u
where couleur = 'Rouge' 
and ville in ('Sochaux','Paris')
and l.np = p.np
and l.nf = f.nf
and l.nu = u.nu;

--12
SELECT DISTINCT Livraison.NP
FROM Livraison
JOIN Usine ON Livraison.NU = Usine.NU
JOIN Fournisseur ON Livraison.nf = Fournisseur.nf
WHERE Usine.Ville = Fournisseur.Ville;
--13
SELECT DISTINCT Livraison.NU
FROM Livraison
JOIN Usine ON Livraison.NU = Usine.NU
JOIN Fournisseur ON Livraison.nf = Fournisseur.nf
WHERE Usine.Ville != Fournisseur.Ville;
-- requete avec jointure
--14
SELECT nf
FROM Livraison
WHERE NU = 1
INTERSECT
SELECT nf
FROM Livraison
WHERE NU = 2;
--15
SELECT DISTINCT Livraison.NU
FROM Livraison
WHERE Livraison.NP IN (
    SELECT NP
    FROM Livraison
    WHERE nf = 3
);
--16
SELECT NU
FROM Livraison
GROUP BY NU
HAVING COUNT(DISTINCT nf) = 1 and nf = 3;
--17
SELECT Usine.NomU
FROM Usine
WHERE Usine.NU NOT IN (
    SELECT Livraison.NU
    FROM Livraison
    JOIN Produit ON Livraison.NP = Produit.NP
    JOIN Fournisseur ON Livraison.nf = Fournisseur.nf
    WHERE Produit.Couleur = 'rouge' AND Fournisseur.Ville = 'Paris'
);
--18
SELECT COUNT(*) AS TotalFournisseurs
FROM Fournisseur;
--19
SELECT COUNT(*) AS ProduitsAvecCouleur
FROM Produit
WHERE Couleur IS NOT NULL;
--20
SELECT AVG(Poids) AS MoyennePoids
FROM Produit;
--21
SELECT SUM(Poids) AS SommePoidsVerts
FROM Produit
WHERE Couleur = 'vert';
--22
SELECT MIN(Poids) AS PoidsMin
FROM Produit
WHERE Couleur IS NOT NULL;
--23
SELECT nf, COUNT(distinct np) AS NbProduitsLivres
FROM Livraison
GROUP BY nf;
--24
SELECT Couleur, AVG(Poids) AS PoidsMoyen
FROM Produit
GROUP BY Couleur;
--25
SELECT Couleur
FROM Produit
GROUP BY Couleur
HAVING AVG(Poids) > 10;
--26
SELECT COUNT(DISTINCT Livraison.NP) AS NbProduits
FROM Livraison
JOIN Fournisseur ON Livraison.nf = Fournisseur.nf
WHERE Fournisseur.Ville = 'Paris';
--27 les produits les plus
SELECT NP
FROM Produit
WHERE Poids = (SELECT MIN(Poids) FROM Produit);
--28
SELECT Fournisseur.nf, COUNT(Livraison.NP) AS NbProduitsLivres
FROM Livraison
JOIN Fournisseur ON Livraison.nf = Fournisseur.nf
GROUP BY Fournisseur.nf;
--nombre de produit qun usine acheter 
select nu from livraison where nf=3 group by nu having count(distinct np) =
(select count(distinct np) from livraison where nf=3);
--29
select l.np , count(distinct l.nu) from livraison l , usine u where u.ville ='Paris'
and l.nu = u.nu group by l.np;
--30 
select u , nu , sum(quantite) from livraison group by nu;
select nf , count (distinct np) as nbprod from 
livraison group by nf;
--31
select nomf from fournisseur where nf in (select numf from V1 where nbprod =(select max(nbprod) from V1));