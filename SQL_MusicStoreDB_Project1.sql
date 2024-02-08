select * from customer;
select * from artist;
select * from employee;
select * from invoice_line;
select * from invoice;
select * from genre
select * from track
Select * from playlist
select * from album

/* Q1: Who is the senior most employee based on job title?*/

select concat(first_name,last_name)	as Full_Name
from employee
order by levels DESC
LIMIT 1

/* Q2: Which countries have the most Invoices? */
select COUNT(*) AS C, billing_country from invoice 
group by billing_country
order by C DESC;

/* Q3: What are top 3 values of total invoice? */
SELECT total FROM invoice
order by total DESC
Limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice totals */

select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total DESC
Limit 1

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the 
most money.*/

SELECT customer.customer_id, customer.last_name, customer.first_name,
sum(invoice.total) as invoice_total
FROM customer
JOIN invoice
ON invoice.customer_id=customer.customer_id
group by customer.customer_id
order by invoice_total DESC
limit 1;


/* Q6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A. */

/*1st Method - Using Inner Query*/
Select distinct last_name, first_name, email
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
Select track_id from track
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock')
order by email;

/*2nd Method - Using Normal Joins */
SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/* Q8: Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length 
with the longest songs listed first. */

select name, milliseconds
from track 
WHERE milliseconds > 
	(select avg(milliseconds) as avg_length_track 
	 from track)
ORDER BY milliseconds DESC

/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

select CONCAT(C.first_name, ' ', C.last_name)cust_name, (A.name)artist_name, SUM(IL.unit_price * IL.quantity) as total_spent
FROM customer C
INNER JOIN invoice I
ON C.customer_id = I.customer_id
INNER JOIN invoice_line IL
ON I.invoice_id = IL.invoice_id
INNER JOIN track T
ON IL.track_id = T.track_id
INNER JOIN album AL
ON T.album_id = AL.album_id
INNER JOIN artist A
ON AL.artist_id = A.artist_id
group by C.first_name, C.last_name, A.name
order by total_spent DESC


/* 10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with popular_genre as
(
SELECT count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
row_number() over(partition by customer.country order by count(invoice_line.quantity) DESC) AS RowNo
from invoice_line
join invoice on invoice_line.invoice_id=invoice.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2,3,4
order by 2, 1 DESC
)

select *
from popular_genre where RowNo <=1

/* 11: Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and 
how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount. */

with cte as 
(select customer.customer_id,customer.first_name,customer.last_name,invoice.billing_country,SUM(invoice.total) AS total_spending,
row_number() over (partition by invoice.billing_country order by sum(invoice.total) DESC) as rowno
from invoice
join customer on customer.customer_id=invoice.customer_id
GROUP BY 1,2,3, 4
ORDER BY 4 ASC, 5 desc
)

select * from cte where rowno <=1












