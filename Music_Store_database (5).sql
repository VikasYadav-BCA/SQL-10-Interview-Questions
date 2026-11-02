--1. Who is the senior most employee based on job title?----------------------------

select * from employee
order by levels desc limit 1

-- 2. Which countries have the most Invoices?------------------------------------------

SELECT count(*) as invoices, billing_country  from 
invoice group by billing_country
order by invoices desc

--3. What are top 3 values of total invoice?-------------------------------------

select total  from invoice
order by total  desc limit 3

/*4. Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals*/-------------------------------------------------------

select  sum(total) as invoice_total , billing_city
from invoice
group by billing_city
order by invoice_total desc



/*5. Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money */-------------------------------------------------

select   customer.customer_id, customer.first_name,  customer.last_name, SUM(invoice.total) as
total from customer
join invoice ON customer.cUstomer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 2

--6. Write query to return the email, first name, last name, & Genre of all Rock Music
--listeners. Return your list ordered alphabetically by email starting with A

select distinct email, first_name, last_name from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
 select  track_id from track
 join genre on track.genre_id = genre.genre_id
 where genre.name like 'Rock'
)
order by email;

--7. Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands

SELECT artist.artist_id, artist.name,
COUNT(artist.artist_id) AS number_of_songs
FROM track
  JOIN album ON album.album_id = track.album_id
 JOIN artist ON artist.artist_id = album.artist_id
    JOIN genre ON genre.genre_id = track.genre_id
 WHERE genre.name LIKE 'Rock'
 GROUP BY artist.artist_id
   ORDER BY number_of_songs DESC
    LIMIT 10;

/* 8. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first */

SELECT name, milliseconds 
from track
where milliseconds > ( 
    select avg(milliseconds) as avg_milliseconds
	from track)

	order by  milliseconds desc

--9==. Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent----------------------------------

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist ar
    ON al.artist_id = ar.artist_id
      GROUP BY
    c.customer_id, c.first_name,
    c.last_name, ar.artist_id,
    ar.name  ORDER BY total_spent DESC;

