-- ** How to import your data. **

-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name ‘Joins’ (not the apostrophes). Click Save.

-- 3. Left click the server ‘Joins’. Left click Schemas. 

-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT specs.film_title AS Film_Name, 
	specs.release_year AS Year_Films_Released,
	MIN(revenue.worldwide_gross) AS Lowest_Grossing_Films
FROM specs
LEFT JOIN revenue
ON specs.movie_id = revenue.movie_id
GROUP BY specs.film_title, specs.release_year
ORDER BY MIN(revenue.worldwide_gross)


-- 2. What year has the highest average imdb rating?

SELECT
	AVG(rating.imdb_rating) AS imdb_rating,
	specs.release_year AS year
FROM specs
LEFT JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY year
ORDER BY imdb_rating DESC
LIMIT 1;
-- 1991 , 7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT
	MAX(revenue.worldwide_gross),
	specs.mpaa_rating,
	distributors.company_name,
	specs.film_title
FROM revenue
JOIN specs
ON specs.movie_id = revenue.movie_id
JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
WHERE specs.mpaa_rating = 'G'
GROUP BY specs.mpaa_rating,distributors.company_name,specs.film_title
ORDER BY MAX(revenue.worldwide_gross) DESC
ORDER BY MAX(revenue.worldwide_gross) DESC

-- Disney and Toy Story 4 and the whole franchise taking the top place

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT
	distributors.company_name,
	COUNT(specs.film_title)
FROM specs
LEFT JOIN distributors
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY COUNT(specs.film_title) DESC


-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT distributors.company_name,
	AVG(revenue.film_budget)
FROM distributors
JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
JOIN revenue
ON revenue.movie_id = specs.movie_id
GROUP BY distributors.company_name
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT
	COUNT(specs.*) AS Number_of_films,
	specs.film_title AS films,
	distributors.company_name AS company,
	distributors.headquarters AS Location,
	rating.imdb_rating AS Rating
FROM distributors
JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
JOIN rating
ON rating.movie_id = specs.movie_id
WHERE distributors.headquarters NOT LIKE '%CA%'
GROUP BY distributors.company_name, rating.imdb_rating, distributors.headquarters,specs.film_title
ORDER BY COUNT(specs.film_title) 

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT
	avg(rating.imdb_rating)AS Rating,
	specs.length_in_min AS Length_Minutes,
	CASE WHEN length_in_min > '120' THEN 'Good'
		WHEN length_in_min < '120' THEN 'Bad'
		ELSE 'both' END AS Movies
FROM rating
JOIN specs
ON rating.movie_id = specs.movie_id
GROUP BY specs.length_in_min
ORDER BY avg(rating.imdb_rating) DESC
