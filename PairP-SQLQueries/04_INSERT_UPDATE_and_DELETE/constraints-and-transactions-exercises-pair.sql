-- Write queries to return the following:
-- Make the following changes in the "world" database.

-- 1. Add Superman's hometown, Smallville, Kansas to the city table. The 
-- countrycode is 'USA', and population of 45001. (Yes, I looked it up on 
-- Wikipedia.)

SELECT * FROM city ORDER BY id;

INSERT INTO city (name, countrycode, district, population)
VALUES ('Smallville', 'USA', 'Kansas', 45001);

-- 2. Add Kryptonese to the countrylanguage table. Kryptonese is spoken by 0.0001
-- percentage of the 'USA' population.

SELECT * FROM countrylanguage ORDER BY countrycode;

INSERT INTO countrylanguage (countrycode, language, isofficial, percentage)
VALUES ('USA', 'Kryptonese', FALSE, 0.0001);

-- 3. After heated debate, "Kryptonese" was renamed to "Krypto-babble", change 
-- the appropriate record accordingly.

SELECT * FROM countrylanguage WHERE language = 'Kryptonese';

UPDATE countrylanguage
SET language = 'Krypto-babble'
WHERE language = 'Kryptonese';

SELECT * FROM countrylanguage WHERE language = 'Krypto-babble';

-- 4. Set the US captial to Smallville, Kansas in the country table.

SELECT id FROM city WHERE name = 'Smallville'; -- 4080

SELECT * FROM country WHERE code = 'USA';

UPDATE country
SET capital = (SELECT id FROM city WHERE name = 'Smallville')
WHERE code = 'USA';

SELECT * FROM country WHERE code = 'USA'; -- 3813

-- 5. Delete Smallville, Kansas from the city table. (Did it succeed? Why?)

START TRANSACTION;

    SELECT * FROM city WHERE name = 'Smallville';

    DELETE FROM city
    WHERE name = 'Smallville' AND countrycode = 'USA';

    SELECT * FROM city WHERE name = 'Smallville';

ROLLBACK;

-- Foreign key constraint will not allow the following city, state to be removed from the table

-- update or delete on table "city" violates foreign key constraint "country_capital_fkey" on table "country"

-- 6. Return the US captial to Washington.

SELECT * FROM country WHERE code = 'USA';
SELECT id FROM city WHERE name = 'Washington';

UPDATE country
SET capital = (SELECT id FROM city WHERE name = 'Washington')
WHERE code = 'USA';

SELECT * FROM country WHERE code = 'USA';


-- 7. Delete Smallville, Kansas from the city table. (Did it succeed? Why?)

START TRANSACTION;

    SELECT * FROM city WHERE name = 'Smallville';

    DELETE FROM city
    WHERE name = 'Smallville' AND countrycode = 'USA';

    SELECT * FROM city WHERE name = 'Smallville';

ROLLBACK;

-- No longer has the following association to the country table as the capital of the 'USA'

-- 8. Reverse the "is the official language" setting for all languages where the
-- country's year of independence is within the range of 1800 and 1972 
-- (exclusive). 
-- (590 rows affected)

UPDATE countrylanguage
SET isofficial = NOT isofficial
WHERE countrycode IN (SELECT code FROM country WHERE indepyear >= 1800 AND indepyear <= 1972);

-- 9. Convert population so it is expressed in 1,000s for all cities. (Round to
-- the nearest integer value greater than 0.)
-- (4079 rows affected)

UPDATE city
SET population = population / 1000;

-- 10. Assuming a country's surfacearea is expressed in miles, convert it to 
-- meters for all countries where French is spoken by more than 20% of the 
-- population.
-- (7 rows affected)
UPDATE country
SET surfacearea = surfacearea * 1609.34
WHERE surfacearea IN (SELECT surfacearea FROM country JOIN countrylanguage ON countrylanguage.countrycode = country.code WHERE countrylanguage.language = 'French' AND percentage > 20);