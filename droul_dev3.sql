
SET SERVEROUTPUT ON;
--qst1
CREATE OR REPLACE FUNCTION nombre_usines(ville_nom VARCHAR) RETURN NUMBER IS
    v_nombre NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_nombre FROM usine1 WHERE ville = ville_nom;
    RETURN v_nombre;
END;
/
--qst2
CREATE OR REPLACE PROCEDURE PoidsTotalFournisseurCursor IS
    CURSOR cur_fournisseurs IS
        SELECT f.nf, f.nomf, SUM(p.poids * l.quantite) AS poids_total
        FROM fournisseur1 f
        JOIN livraison1 l ON f.nf = l.nf
        JOIN produit1 p ON l.np = p.np
        GROUP BY f.nf, f.nomf;

    v_fournisseur_id fournisseur1.nf%TYPE;
    v_nom_fournisseur fournisseur1.nomf%TYPE;
    v_poids_total NUMBER;
BEGIN
    OPEN cur_fournisseurs;
    LOOP
        FETCH cur_fournisseurs INTO v_fournisseur_id, v_nom_fournisseur, v_poids_total;
        EXIT WHEN cur_fournisseurs%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Fournisseur: ' || v_nom_fournisseur || ' | Poids total livré: ' || NVL(v_poids_total, 0) || ' kg');
    END LOOP;
    CLOSE cur_fournisseurs;
END;
/
--qst 3
CREATE OR REPLACE PROCEDURE fournisseur_max_livraison(ville_nom VARCHAR) IS
    CURSOR c_fournisseurs IS
        SELECT l.nf, SUM(l.quantite) AS total_quantite
        FROM livraison1 l
        JOIN usine1 u ON l.nu = u.nu
        WHERE u.ville = ville_nom
        GROUP BY l.nf
        ORDER BY total_quantite DESC;
    v_max_fournisseur fournisseur1.nf%TYPE;
    v_max_quantite NUMBER;
BEGIN
    OPEN c_fournisseurs;
    FETCH c_fournisseurs INTO v_max_fournisseur, v_max_quantite;
    IF c_fournisseurs%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Fournisseur ayant livré le plus de produits à ' || ville_nom || ' : ' || v_max_fournisseur || ' (' || v_max_quantite || ' produits)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucune livraison trouvée pour cette ville.');
    END IF;
    CLOSE c_fournisseurs;
END;
/

--qst4 
CREATE OR REPLACE PROCEDURE fournisseur_max_produit(p_np INTEGER) IS
    CURSOR c_fournisseurs IS
        SELECT l.nf, SUM(l.quantite) AS total_quantite
        FROM livraison1 l
        WHERE l.np = p_np
        GROUP BY l.nf
        ORDER BY total_quantite DESC;
    v_max_fournisseur fournisseur1.nf%TYPE;
    v_max_quantite NUMBER;
BEGIN
    OPEN c_fournisseurs;
    FETCH c_fournisseurs INTO v_max_fournisseur, v_max_quantite;
    IF c_fournisseurs%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Fournisseur ayant livré le plus de quantité du produit ' || p_np || ' : ' || v_max_fournisseur || ' (' || v_max_quantite || ' unités)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucune livraison trouvée pour ce produit.');
    END IF;
    CLOSE c_fournisseurs;
END;
/
CREATE OR REPLACE PROCEDURE fournisseur_tous IS
    CURSOR c_produits IS SELECT DISTINCT np FROM produit1;
BEGIN
    FOR p IN c_produits LOOP
        fournisseur_max_produit(p.np);
    END LOOP;
END;
/
-- 5. Ajout de la colonne date_livraison et remplissage aléatoire
ALTER TABLE livraison1 ADD date_livraison DATE;
BEGIN
    FOR r IN (SELECT np FROM livraison1) LOOP
        UPDATE livraison1
        SET date_livraison = TO_DATE('01/02/2025', 'DD/MM/YYYY') +
            FLOOR(DBMS_RANDOM.VALUE(0, (TO_DATE('30/04/2025', 'DD/MM/YYYY') - TO_DATE('01/02/2025', 'DD/MM/YYYY'))))
        WHERE np = r.np;
    END LOOP;
END;
/
--6
ALTER TABLE livraison1 ADD date_livraison DATE;
BEGIN
    FOR r IN (SELECT np FROM livraison1) LOOP
        UPDATE livraison1
        SET date_livraison = TO_DATE('01/02/2025', 'DD/MM/YYYY') +
            FLOOR(DBMS_RANDOM.VALUE(0, (TO_DATE('30/04/2025', 'DD/MM/YYYY') - TO_DATE('01/02/2025', 'DD/MM/YYYY'))))
        WHERE np = r.np;
    END LOOP;
END;
/
--7
CREATE OR REPLACE PROCEDURE total_produits_par_mois IS
    CURSOR c_mois IS
        SELECT TO_CHAR(date_livraison, 'YYYY-MM') AS mois, SUM(quantite) AS total_quantite
        FROM livraison1
        GROUP BY TO_CHAR(date_livraison, 'YYYY-MM')
        ORDER BY mois;
BEGIN
    FOR rec IN c_mois LOOP
        DBMS_OUTPUT.PUT_LINE('Mois: ' || rec.mois || ' - Produits livrés: ' || rec.total_quantite);
    END LOOP;
END;
/
