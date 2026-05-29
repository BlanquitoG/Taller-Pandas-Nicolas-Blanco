USE sakila;

-- PARTE 1 – SELECT y WHERE

-- 1. Mostrar nombre y apellido de todos los clientes

-- Seleccionamos las columnas first_name y last_name
-- de la tabla customer
SELECT first_name, last_name
FROM customer;

-- 2. Películas con duración mayor a 120 minutos

-- Seleccionamos el título y duración de las películas
-- cuya duración sea mayor a 120 minutos
SELECT title, length
FROM film
WHERE length > 120;

-- PARTE 2 – ORDER BY

-- 3. Ordenar clientes por apellido (A-Z)

-- ORDER BY permite ordenar los resultados
-- ASC significa orden ascendente
SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC;

-- 4. Top 5 películas más largas

-- Ordenamos las películas por duración
-- DESC significa descendente (de mayor a menor)
-- LIMIT 5 muestra solo las primeras 5 filas
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 5;

-- PARTE 3 – INNER JOIN

-- 5. Cantidad pagada y fecha del pago con nombre del cliente

-- INNER JOIN une tablas que tienen relación
-- payment.customer_id = customer.customer_id
SELECT 
    customer.first_name,
    customer.last_name,
    payment.amount,
    payment.payment_date
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id;

-- 6. Películas alquiladas

-- rental se conecta con inventory
-- inventory se conecta con film
-- Esto permite obtener el nombre de la película alquilada
SELECT 
    rental.rental_id,
    film.title,
    rental.rental_date
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id;

-- PARTE 4 – LEFT JOIN

-- 7. Clientes sin pagos

-- LEFT JOIN trae todos los clientes aunque no tengan pagos
-- WHERE payment_id IS NULL filtra únicamente
-- los clientes que nunca han realizado pagos
SELECT 
    customer.first_name,
    customer.last_name
FROM customer
LEFT JOIN payment
ON customer.customer_id = payment.customer_id
WHERE payment.payment_id IS NULL;

-- 8. Películas que no tienen actores

-- film_actor relaciona películas con actores
-- Si film_actor.actor_id es NULL significa
-- que la película no tiene actores registrados
SELECT 
    film.title,
    film.length
FROM film
LEFT JOIN film_actor
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IS NULL;

-- PARTE 5 – INSERT, UPDATE, DELETE

-- 9. Insertar actor temporal

-- Insertamos un nuevo actor en la tabla actor
INSERT INTO actor(first_name, last_name, last_update)
VALUES ('TEMPORAL', 'ACTOR', NOW());

-- 10. Verificar el actor insertado

-- Buscamos el actor temporal para conocer su actor_id
-- actor_id es la llave primaria de la tabla
SELECT *
FROM actor
WHERE first_name = 'TEMPORAL';

-- 11. Actualizar actor

-- Actualizamos el apellido del actor temporal
-- usando actor_id para evitar el error 1175
-- Reemplaza el número 201 por el actor_id real
UPDATE actor
SET last_name = 'MODIFICADO'
WHERE actor_id = 201;

-- 12. Eliminar actor

-- Eliminamos el actor temporal usando actor_id
-- Reemplaza el número 201 por el actor_id real
DELETE FROM actor
WHERE actor_id = 201;

-- PARTE 6 – CONSULTAS AVANZADAS

-- 13. Top 5 clientes que más dinero han pagado

-- SUM(amount) suma todos los pagos de cada cliente
-- GROUP BY agrupa los resultados por cliente
-- ORDER BY organiza de mayor a menor
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS total_pagado
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY total_pagado DESC
LIMIT 5;

-- 14. Top 5 películas más alquiladas

-- COUNT cuenta cuántas veces fue alquilada cada película
-- GROUP BY agrupa por película
-- ORDER BY organiza de mayor a menor
SELECT 
    film.title,
    COUNT(rental.rental_id) AS veces_alquilada
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.film_id
ORDER BY veces_alquilada DESC
LIMIT 5;