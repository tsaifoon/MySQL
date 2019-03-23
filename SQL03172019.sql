USE sakila;

-- look at full table --
SELECT * FROM actor;

-- 1a --
SELECT
	first_name,
    last_name
FROM actor;

-- 1b --
SELECT
	CONCAT(first_name," ",last_name) as actor_name
FROM actor;

-- 2a --
SELECT
	actor_id,
    first_name,
    last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b --
SELECT
	first_name,
	last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c --
SELECT
	last_name,
    first_name
FROM actor
WHERE last_name LIKE '%LI%'; 


-- Look at country table --
SELECT * FROM country;
-- 2d -- 
SELECT 
	country_id, 
	country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a --
ALTER TABLE actor
ADD description BLOB;
-- check --
SELECT * FROM actor;

-- 3b --
ALTER TABLE actor
DROP COLUMN description;
-- check --
SELECT * FROM actor;

-- 4a --
SELECT
	last_name,
    COUNT(last_name) as count_of_last_name
FROM
	actor
GROUP BY
	last_name;
    
-- 4b --
SELECT
	last_name,
    COUNT(last_name) as count_of_last_name
FROM
	actor
GROUP BY
	last_name
HAVING count_of_last_name > 1;

-- 4c --
-- look at first names with groucho --
SELECT * FROM actor WHERE first_name = "GROUCHO" && last_name = "WILLIAMS";

UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" && last_name = "WILLIAMS";

-- 4d --
-- make sure theres only one HARPO WILLIAMS --
SELECT * FROM actor WHERE first_name = "HARPO" && last_name = "WILLIAMS";
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" && last_name = "WILLIAMS";
-- check -- 
SELECT * FROM actor WHERE first_name = "HARPO" && last_name = "WILLIAMS";

-- 5a --
SHOW CREATE TABLE sakila.address; 

-- 6a -- 
-- looking at both tables --
SELECT * FROM staff;
SELECT * FROM address;

SELECT
    S.first_name, S.last_name, A.address
FROM
    staff AS S
JOIN address as A
ON (S.address_id = A.address_id);

-- 6b --
SELECT * FROM payment;
SELECT
    S.first_name, S.last_name, SUM(P.amount) as total_amount
FROM
    staff AS S
JOIN payment as P
ON (S.staff_id = P.staff_id)
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY first_name;

-- 6c -- 
SELECT * FROM film;
SELECT * FROM film_actor ORDER BY film_id;

SELECT
	F.title, count(A.actor_id) as total_actors
FROM
	film as F
INNER JOIN
	film_actor as A
ON (F.film_id = A.film_id)
GROUP BY title;

-- 6d --
SELECT * FROM inventory;
SELECT * FROM film;

SELECT
	COUNT(I.inventory_id) as total_inventory, I.film_id, F.title
FROM
	inventory as I
INNER JOIN
	film as F
ON (I.film_id = F.film_id)
WHERE F.title = "Hunchback Impossible";

-- 6e --
SELECT * FROM payment;
SELECT * FROM customer;

SELECT
	C.first_name, C.last_name, SUM(P.amount) as total_paid
FROM
	customer as C
INNER JOIN
	payment as P
ON (C.customer_id = P.customer_id)
GROUP BY last_name;

-- 7a --
SELECT * FROM film;
SELECT * FROM language;


SELECT title
FROM film
WHERE (title LIKE "K%" OR title LIKE "Q%") AND language_id IN
(
  SELECT language_id
  FROM language
  WHERE name = "English"
);

-- 7b --
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN 
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
    )
);

-- 7c --
SELECT * FROM customer;
SELECT * FROM country;
SELECT * FROM address;
SELECT * FROM city;

SELECT A.first_name, A.last_name, A.email
FROM customer AS A
INNER JOIN address AS B ON A.address_id = B.address_id
INNER JOIN city as C on C.city_id = B.city_id
INNER JOIN country as D on D.country_id = C.country_id
WHERE D.country = "Canada";

-- 7d -- 
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

SELECT A.title
FROM film AS A
INNER JOIN film_category AS B ON A.film_id = B.film_id
INNER JOIN category AS C ON C.category_Id = B.category_id
WHERE C.name = "Family";

-- 7e -- 
SELECT * FROM rental;
SELECT * FROM film;
SELECT * from inventory;

SELECT A.title, COUNT(B.film_id) AS "Rental Count"
FROM film AS A
INNER JOIN inventory AS B ON A.film_id = B.film_id
INNER JOIN rental as C ON C.inventory_id = B.inventory_id
GROUP BY A.title 
ORDER BY COUNT(B.film_id) DESC;

-- 7f --
SELECT * FROM payment;
SELECT * FROM inventory;
SELECT * FROM rental;

SELECT I.store_id, SUM(P.amount) as "Total Payment"
FROM payment AS P
INNER JOIN rental AS R ON R.rental_id = P.rental_id
INNER JOIN inventory AS I ON I.inventory_id = R.inventory_id
GROUP BY I.store_id;

-- 7g --
SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT S.store_id, CO.city, CT.country
FROM store AS S
INNER JOIN address AS A ON A.address_id = S.address_id
INNER JOIN city AS CO ON CO.city_id = A.city_id
INNER JOIN country AS CT ON CT.country_id = CO.country_id;

-- 7h -- 
SELECT * FROM category;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film_category;

SELECT C.name, SUM(P.amount) AS "GROSS REVENUE"
FROM payment AS P
INNER JOIN rental AS R ON R.rental_id = P.rental_id
INNER JOIN inventory AS I ON I.inventory_id = R.inventory_id
INNER JOIN film_category AS F ON F.film_id = I.film_id
INNER JOIN category AS C ON C.category_id = F.category_id
GROUP BY C.name
ORDER BY SUM(P.amount) DESC
LIMIT 5;

-- 8a --
CREATE VIEW Gross_Revenue AS (
	SELECT C.name, SUM(P.amount) AS "GROSS REVENUE"
	FROM payment AS P
	INNER JOIN rental AS R ON R.rental_id = P.rental_id
	INNER JOIN inventory AS I ON I.inventory_id = R.inventory_id
	INNER JOIN film_category AS F ON F.film_id = I.film_id
	INNER JOIN category AS C ON C.category_id = F.category_id
	GROUP BY C.name
	ORDER BY SUM(P.amount) DESC
	LIMIT 5
);

-- 8b --
SELECT * FROM Gross_Revenue;

-- 8c --
DROP VIEW Gross_Revenue;
