/*

    1- Rank films by length.
    
    2- Rank films by length within the rating category.
    
    3- Rank languages by the number of films (as original language).
    
    4- Rank categories by the number of films.
    
    5- Which actor has appeared in the most films?
    
    6- Most active customer.
    
    7- Most rented film.
*/
use sakila;
--    1- Rank films by length.

select title, length, dense_rank() over (order by length asc) from film;


--   2- Rank films by length within the rating category.

select title, length, rating, dense_rank() over (partition by rating order by length asc) from film;


--     3- Rank languages by the number of films (as original language).

select title, original_language_id,dense_rank() over (partition by original_language_id order by count(original_language_id) asc) from film;



--     4- Rank categories by the number of films.

select film_id, c.name,count(film_id) as num_film,c.category_id, dense_rank() over (order by  count(film_id)) as 'rank' from film_category
join category as c
on film_category.category_id = c.category_id
group by category_id;

/*
select c.name, count(cf.film_id)  from category as c
 join film_category as cf 
 on cf.category_id = c.category_id
 group by c.name
 order by count(cf.film_id);
 */

--     5- Which actor has appeared in the most films?



select  first_name,last_name,a.actor_id, count(fa.film_id)  as 'num_rental' from actor as a
join film_actor as fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by count(fa.film_id) desc limit  1;




--     6- Most active customer.

select  first_name,last_name,c.customer_id, count(r.rental_id)  as 'num_rental' from customer as c
join rental as r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by count(r.rental_id) desc limit  1;




--     7- Most rented film.

SELECT film.title,film.film_id,count(r.rental_id) as 'num_rental'
FROM rental as r
    INNER JOIN inventory as i ON i.inventory_id = r.inventory_id
    INNER JOIN  film ON i.film_id  = film.film_id
group by film.title
ORDER BY count(r.rental_id) desc;
