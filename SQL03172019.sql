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
WHERE language_id IN
(
  SELECT language_id
  FROM language
  WHERE name = "English"
);

-- 7b --
