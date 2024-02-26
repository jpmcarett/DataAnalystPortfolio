-- Query 1: Select all columns from the filter_info table
SELECT *
FROM [Covid_project_2].dbo.filter_info;

-- Query 2: Select distinct locations from the filter_info table
SELECT DISTINCT location
FROM COVID_PROJECT_2.DBO.FILTER_INFO;

-- Query 3: Select distinct locations excluding specified categories, sorted alphabetically
SELECT DISTINCT LOCATION
FROM COVID_PROJECT_2.DBO.FILTER_INFO
WHERE LOCATION NOT IN (
    'Low income', 'NULL', 'Europe','Africa','Asia','European Union','High income','South America','North America',
    'Upper middle income','United Kingdom','Lower middle income','World','Oceania',
    '',
    -- Additional countries
    'Bonaire Sint Eustatius and Saba','Faeroe Islands','French Guiana','Gibraltar','Greenland','Guadeloupe',
    'Guernsey','Isle of Man','Jersey','Kosovo','Macao','Martinique','Mayotte','Micronesia (country)',
    'Montserrat','New Caledonia','Niue','Pitcairn','Reunion','Saint Barthelemy', 'Saint Helena',
    'Saint Martin (French part)','Saint Pierre and Miquelon', 'Saint Vincent and the Grenadines',
    'Scotland','Sint Maarten (Dutch part)','Turks and Caicos Islands',
    'Wallis and Futuna'
)
ORDER BY LOCATION ASC;

-- Query 4: Create a new table with filtered country information
SELECT *
INTO DBO.FILTER_BY_COUNTRY
FROM DBO.FILTER_INFO
WHERE LOCATION NOT IN(
    'Low income', 'NULL', 'Europe','Africa','Asia','European Union','High income','South America','North America',
    'Upper middle income','United Kingdom','Lower middle income','World','Oceania',
    '',
    -- Additional countries
    'Bonaire Sint Eustatius and Saba','Faeroe Islands','French Guiana','Gibraltar','Greenland','Guadeloupe',
    'Guernsey','Isle of Man','Jersey','Kosovo','Macao','Martinique','Mayotte','Micronesia (country)',
    'Montserrat','New Caledonia','Niue','Pitcairn','Reunion','Saint Barthelemy', 'Saint Helena',
    'Saint Martin (French part)','Saint Pierre and Miquelon', 'Saint Vincent and the Grenadines',
    'Scotland','Sint Maarten (Dutch part)','Turks and Caicos Islands',
    'Wallis and Futuna'
);

-- Query 5: Check the number of countries in the new table
SELECT DISTINCT LOCATION
FROM COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY
ORDER BY LOCATION;

-- Query 6: Select all columns from the FILTER_BY_COUNTRY table
SELECT *
FROM COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY;

-- Query 7: Create a filtered dataset with specific conditions
SELECT 
    LOCATION,
    DATE,
    TOTAL_VACCINATIONS,
    PEOPLE_VACCINATED,
    people_fully_vaccinated,
    POPULATION,
    population_density,
    TOTAL_BOOSTERS, 
    (cast(TOTAL_VACCINATIONS as float)/cast(population as float))*100 as TOTALV_VS_POPULATION,
    (cast(PEOPLE_FULLY_VACCINATED as float)/cast(population as float))*100 as PEOPLE_FULLYV_VS_POPULATION,
    (cast(TOTAL_BOOSTERS as float)/cast(population as float))*100 as TOTAL_BOOSTER_VS_POPULATION
INTO DATA_FILTER_2
FROM COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY
WHERE people_fully_vaccinated NOT LIKE '0'
AND total_vaccinations NOT LIKE '0';

-- Query 8: Analyze the data to find the latest date for max new deaths per country
SELECT 
    fc.LOCATION,
    fc.DATE,
    fc.new_deaths AS max_new_deaths
FROM 
    COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY fc
INNER JOIN (
    SELECT 
        LOCATION,
        MAX(new_deaths) AS max_new_deaths
    FROM 
        COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY
    GROUP BY 
        LOCATION
) max_deaths ON fc.LOCATION = max_deaths.LOCATION AND fc.new_deaths = max_deaths.max_new_deaths
WHERE max_new_deaths NOT LIKE 0
ORDER BY 
    fc.LOCATION;

-- Query 9: Analyze the data to find the latest date for max new cases per country
SELECT 
    fc.LOCATION,
    fc.DATE,
    fc.new_cases AS max_new_cases
FROM 
    COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY fc
INNER JOIN (
    SELECT 
        LOCATION,
        MAX(new_cases) AS max_new_cases
    FROM 
        COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY
    GROUP BY 
        LOCATION
) max_cases ON fc.LOCATION = max_cases.LOCATION AND fc.new_cases = max_cases.max_new_cases
WHERE 
    max_new_cases <> 0
ORDER BY


-- Query 10 to retrieve the locations and respective dates for the maximum new cases and maximum new deaths per country
SELECT 
    max_cases.LOCATION,
    max_cases.DATE AS date_max_new_cases,  -- Date for the maximum new cases
    max_cases.max_new_cases,               -- Maximum new cases
    max_deaths.DATE AS date_max_new_deaths, -- Date for the maximum new deaths
    max_deaths.max_new_deaths              -- Maximum new deaths
FROM 
    (
        -- Subquery to get the location, date, and maximum new cases
        SELECT 
            fc.LOCATION,
            fc.DATE,
            fc.new_cases AS max_new_cases
        FROM 
            COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY fc
        INNER JOIN (
            -- Subquery to get the maximum new cases per location
            SELECT 
                LOCATION,
                MAX(new_cases) AS max_new_cases
            FROM 
                COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY
            GROUP BY 
                LOCATION
        ) max_cases ON fc.LOCATION = max_cases.LOCATION AND fc.new_cases = max_cases.max_new_cases
        WHERE 
            max_new_cases <> 0
    ) max_cases
INNER JOIN 
    (
        -- Subquery to get the location, date, and maximum new deaths
        SELECT 
            fc.LOCATION,
            fc.DATE,
            fc.new_deaths AS max_new_deaths
        FROM 
            COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY fc
        INNER JOIN (
            -- Subquery to get the maximum new deaths per location
            SELECT 
                LOCATION,
                MAX(new_deaths) AS max_new_deaths
            FROM 
                COVID_PROJECT_2.DBO.FILTER_BY_COUNTRY
            GROUP BY 
                LOCATION
        ) max_deaths ON fc.LOCATION = max_deaths.LOCATION AND fc.new_deaths = max_deaths.max_new_deaths
        WHERE 
            max_new_deaths <> 0
    ) max_deaths ON max_cases.LOCATION = max_deaths.LOCATION
ORDER BY 
    max_cases.LOCATION;







