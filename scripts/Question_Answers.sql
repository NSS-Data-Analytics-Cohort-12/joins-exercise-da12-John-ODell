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

