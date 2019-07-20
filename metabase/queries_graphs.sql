
-- Countries By Month

SELECT * FROM 
(
SELECT country_list.initials AS country, country_list.full_name, years.year, date.month, date.month_num, sum("TOTAL") AS total
,ROW_NUMBER () OVER (PARTITION BY years.year, date.month ORDER BY sum("TOTAL") desc) as Country_Position
FROM "public"."migration_stage"
JOIN country_list ON "public"."migration_stage"."EN_COUNTRY_OF_CITIZENSHIP" = country_list.full_name
JOIN countries ON country_list.full_name = countries.country
JOIN years ON years.year = migration_stage."EN_YEAR"
JOIN date ON date.month = migration_stage."EN_MONTH" and date.quarter = migration_stage."EN_QUARTER"
where {{country}} and {{date_month}} and {{years_flt}} 
group by 1, 2, 3, 4, 5
having sum("TOTAL") > 0
) A
WHERE Country_Position <= 5
Order by 3, 5, 7


-- Top 10 Countries

SELECT * FROM 
(
SELECT country_list.initials AS country, country_list.full_name as Country_Name, sum("TOTAL") AS total
,ROW_NUMBER () OVER ( ORDER BY sum("TOTAL") desc) as Country_Position
FROM "public"."migration_stage"
JOIN country_list ON "public"."migration_stage"."EN_COUNTRY_OF_CITIZENSHIP" = country_list.full_name
JOIN countries ON country_list.full_name = countries.country
JOIN years ON years.year = migration_stage."EN_YEAR"
JOIN date ON date.month = migration_stage."EN_MONTH" and date.quarter = migration_stage."EN_QUARTER"
where {{country}} and {{date_month}} and {{years_flt}} 
group by 1, 2
having sum("TOTAL") > 0
) A
WHERE Country_Position <= 10

-- Top 5 Countries Bar

SELECT country_full, year, sum(total) as total FROM 
(
SELECT country_list.initials AS country, country_list.full_name country_full, years.year as year, sum("TOTAL") AS total
,ROW_NUMBER () OVER (PARTITION BY years.year ORDER BY sum("TOTAL") desc) as Country_Position
FROM "public"."migration_stage"
JOIN country_list ON "public"."migration_stage"."EN_COUNTRY_OF_CITIZENSHIP" = country_list.full_name
JOIN countries ON country_list.full_name = countries.country
JOIN years ON years.year = migration_stage."EN_YEAR"
where {{country}} and {{years_flt}}
group by 1, 2, 3 
having sum("TOTAL") > 0
) A
WHERE Country_Position <= 5
GROUP BY 1, 2

-- Top 5 Countries By Year

SELECT * FROM 
(
SELECT country_list.initials AS country, country_list.full_name, years.year, sum("TOTAL") AS total
,ROW_NUMBER () OVER (PARTITION BY years.year ORDER BY sum("TOTAL") desc) as Country_Position
FROM "public"."migration_stage"
JOIN country_list ON "public"."migration_stage"."EN_COUNTRY_OF_CITIZENSHIP" = country_list.full_name
JOIN countries ON country_list.full_name = countries.country
JOIN years ON years.year = migration_stage."EN_YEAR"
where {{country}} and {{years_flt}}
group by 1, 2, 3 
having sum("TOTAL") > 0
) A
WHERE Country_Position <= 5

-- Total Migration

SELECT country_list.initials AS country, country_list.full_name, sum("TOTAL") AS total
FROM "public"."migration_stage"
JOIN country_list ON "public"."migration_stage"."EN_COUNTRY_OF_CITIZENSHIP" = country_list.full_name
JOIN countries ON country_list.full_name = countries.country
JOIN years ON years.year = migration_stage."EN_YEAR"
where {{country}} and {{years_year}}
group by 1, 2
having sum("TOTAL") > 0


