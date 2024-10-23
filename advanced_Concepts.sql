/* Views including updated views. Views are stored queries that when invoked produce a result set. A view acts a virtual table */

-- VIEWS
-- ROLLUP
-- 

-- INSTEAD OF TYPING THIS QUERY ALL THE TIME...
SELECT 
    title
    , released_year
    , genre
    , rating 
    , first_name
    , last_name
FROM reviews 
JOIN series ON series.id = reviews.series_id
JOIN reviewers ON reviewers.id = reviews.reviewer_id;


-- WE CAN CREATE A VIEW:
CREATE VIEW full_reviews AS
SELECT 
    title
    , released_year
    , genre
    , rating 
    , first_name
    , last_name
FROM reviews 
JOIN series ON series.id = reviews.series_id
JOIN reviewers ON reviewers.id = reviews.reviewer_id;

 
-- NOW WE CAN TREAT THAT VIEW AS A VIRTUAL TABLE 
-- (AT LEAST WHEN IT COMES TO SELECTING)
SELECT *  FROM full_reviews;


-- 

CREATE VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year;
 
CREATE OR REPLACE VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year DESC;
 
ALTER VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year;
 
DROP VIEW ordered_series;


-- HAVING CLAUSE
SELECT 
    title, 
    AVG(rating),
    COUNT(rating) AS review_count
FROM full_reviews 
GROUP BY title HAVING COUNT(rating) > 1;


-- WITH ROLL-UP 
SELECT title, AVG(rating) FROM full_reviews GROUP BY title WITH ROLLUP;

SELECT AVG(rating) FROM full_reviews;



--------


-- WITH ROLL UP 
SELECT 
  title
  , AVG(rating) 
FROM full_reviews 
GROUP BY title WITH ROLLUP;

SELECT AVG(rating) FROM full_reviews;


--
SELECT 
    title
    , AVG(rating)
FROM full_reviews
GROUP BY title WITH ROLLUP;

--
SELECT  
  title
  , COUNT(rating)
FROM full_reviews
GROUP BY title WITH ROLLUP;
 
--
SELECT 
    first_name
    , released_year
    , genre
    , AVG(rating)
FROM full_reviews
GROUP BY released_year , genre , first_name WITH ROLLUP;
