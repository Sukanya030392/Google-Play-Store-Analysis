#Step 1: 
USE playstore_analysis;

#Step 2: Verify your dataset
SELECT COUNT(*) AS total_rows
FROM google_playstore;

DESCRIBE google_playstore;

#Step 3: Check missing values
SELECT
    COUNT(*) AS total_rows,
    SUM(App IS NULL OR TRIM(App) = '') AS missing_app,
    SUM(Category IS NULL OR TRIM(Category) = '') AS missing_category,
    SUM(Rating IS NULL) AS missing_rating,
    SUM(Reviews IS NULL) AS missing_reviews,
    SUM(Installs IS NULL) AS missing_installs,
    SUM(Price IS NULL) AS missing_price
FROM google_playstore;

#Step 4: Check for duplicate app names
SELECT
    App,
    COUNT(*) AS app_count
FROM google_playstore
GROUP BY App
HAVING COUNT(*) > 1
ORDER BY app_count DESC
LIMIT 20;

#Step 5: Explore the dataset
SELECT
    Category,
    COUNT(*) AS total_apps
FROM google_playstore
GROUP BY Category
ORDER BY total_apps DESC;

#Step 6: Investigate duplicate records
SELECT
    App,
    Category,
    Rating,
    Reviews,
    Installs,
    Type,
    Price,
    `Last Updated`
FROM google_playstore
WHERE App = 'I am rich';

#Step 7: Count unique app categories
SELECT
    COUNT(DISTINCT Category) AS total_categories
FROM google_playstore;

#Findings and observations
#App distribution and ratings by category
#Total installs and reviews by category
#Free vs. paid apps
#Content ratings and paid app prices
#Most-installed, highest-rated, and most expensive apps
#App size vs. installs
#Rating distribution and update-year trends

#Step 8: Count apps by category
SELECT
    Category,
    COUNT(*) AS total_apps
FROM google_playstore
GROUP BY Category
ORDER BY total_apps DESC;

##Business insights - dataset contains 33 categories and 9,659 app records. FAMILY, GAME, and TOOLS together account for approximately 37.8% of all app records. These categories have a substantial presence in this dataset.

#Step 9 — Find the average rating for each category
SELECT
    Category,
    ROUND(AVG(Rating), 2) AS average_rating,
    COUNT(Rating) AS rated_apps
FROM google_playstore
GROUP BY Category
HAVING COUNT(Rating) >= 10
ORDER BY average_rating DESC;

##Business insights -
#1. Highest rating: EDUCATION leads with an average rating of 4.31.
#2. Lowest rating: BUSINESS has the lowest average rating at 2.57.
#3. App quantity vs. rating: FAMILY has the most apps (1,877), but its average rating is 3.68.
#4. Sample size matters: Ratings based on more apps may provide a more reliable comparison.

#Step 10 — Find the most-installed app categories
SELECT
    Category,
    SUM(Installs) AS total_installs
FROM google_playstore
GROUP BY Category
ORDER BY total_installs DESC;

#Business insights: Total installs by category
#1. Highest installs: GAME leads with approximately 13.45 billion total installs.
#2. Strong user reach: COMMUNICATION ranks second with approximately 11.04 billion installs.
#3. Popular utility category: TOOLS ranks third with approximately 8.10 billion installs.
#4. Apps vs. installs: FAMILY has the most app records (1,877), but GAME has the highest total installs.
#5. Education comparison: EDUCATION has a high average rating (4.31) but approximately 190 million total installs, showing that high ratings do not necessarily mean the highest install volume.

#Step 11 — Compare free and paid apps
SELECT
    Type,
    COUNT(*) AS total_apps,
    ROUND(AVG(Rating), 2) AS average_rating,
    ROUND(AVG(Installs), 0) AS average_installs
FROM google_playstore
GROUP BY Type;

#Business insights: Free vs. Paid apps
#1. Free apps dominate: There are 8,904 free apps compared with 754 paid apps.
#2. Higher average rating: Free apps average 3.55, compared with 3.40 for paid apps.
#3. Higher average installs: Free apps average approximately 8.45 million installs, while paid apps average approximately 76,079.
#4. Data-quality issue: One record has a blank app type and should be investigated separately.

#Step 12 - Investigate the blank app type
SELECT
    App,
    Category,
    Rating,
    Installs,
    Type,
    Price
FROM google_playstore
WHERE Type IS NULL
   OR TRIM(Type) = '';

#Business Insight: One FAMILY app has a blank type, zero installs, and a 0.00 rating. Verify the record and exclude it from free-versus-paid analysis until its type is confirmed.

#Step 13 — Correct the free vs. paid analysis
SELECT
    Type,
    COUNT(*) AS total_apps,
    ROUND(AVG(Rating), 2) AS average_rating,
    ROUND(AVG(Installs), 0) AS average_installs
FROM google_playstore
WHERE Type IN ('Free', 'Paid')
GROUP BY Type
ORDER BY total_apps DESC;

#Business Insights: Free vs. Paid Apps
#1. Free apps dominate: 8,904 free apps compared with 754 paid apps.
#2. Higher average rating: Free apps average 3.55, versus 3.40 for paid apps.
#3. Higher average installs: Free apps average approximately 8.45 million installs, compared with 76,079 for paid apps.
#4. Key insight: Free apps achieve substantially greater install reach in this dataset, but installs alone do not determine revenue.

#Step 14 — Analyse app content ratings
SELECT
    `Content Rating`,
    COUNT(*) AS total_apps
FROM google_playstore
GROUP BY `Content Rating`
ORDER BY total_apps DESC;

#Business Insights: Content Ratings
#1. Largest group: Everyone-rated apps dominate with 7,903 apps.
#2. Teen audience: 1,036 apps are rated Teen.
#3. Smallest groups: Only 3 apps are Adults only 18+, and 2 are Unrated.
#4. Key insight: The dataset is heavily dominated by apps suitable for a general audience.

#Step 15 — Analyse paid app prices
SELECT
    COUNT(*) AS total_paid_apps,
    ROUND(AVG(Price), 2) AS average_price,
    MIN(Price) AS minimum_price,
    MAX(Price) AS maximum_price
FROM google_playstore
WHERE Type = 'Paid';

#Business Insights: Paid App Prices
#1. Paid apps: The dataset contains 754 paid apps.
#2. Average price: The average paid app costs 14.06.
#3. Price range: Prices range from 0.99 to 400.00.
#4. Key insight: Paid app pricing varies widely, suggesting different pricing strategies across apps.

#Step 16 — Find the top 10 most-installed apps
SELECT
    App,
    Category,
    Installs,
    Rating
FROM google_playstore
ORDER BY Installs DESC
LIMIT 10;

#Business Insights: Top 10 Most-Installed Apps
#1. Highest installs: All 10 apps have 1 billion recorded installs.
#2. Popular categories: COMMUNICATION and SOCIAL appear frequently in the top 10.
#3. High ratings: Instagram, Google Photos, and Subway Surfers each have a 4.5 rating.
#4. Key insight: Popular apps span multiple categories, showing strong reach across social networking, communication, photography, and gaming.

#Step 17 — Find the top 10 highest-rated apps
SELECT
    App,
    Category,
    Rating,
    Installs
FROM google_playstore
WHERE Rating IS NOT NULL
  AND Installs >= 100000
ORDER BY Rating DESC, Installs DESC
LIMIT 10;

#Business Insights: Highest-Rated Apps
#1. Highest rating: All 10 apps have a rating of 4.9.
#2. Leading category: HEALTH_AND_FITNESS appears three times in the results.
#3. High reach: Six Pack in 30 Days has 10 million installs and a 4.9 rating.
#4. Key insight: Highly rated apps appear across multiple categories, and some also achieve substantial install counts.

#Step 18 — Analyse the relationship between reviews and installs
SELECT
    App,
    Category,
    Reviews,
    Installs
FROM google_playstore
ORDER BY Reviews DESC
LIMIT 10;

#Step 18 — Business Insights: Reviews vs. Installs
#1. Most reviews: Facebook leads with approximately 78.2 million reviews.
#2. High engagement: WhatsApp and Instagram also have over 66 million reviews each.
#3. Installs and reviews: Highly installed apps generally have high review counts in this top-10 list.
#4. Key insight: Review volume can indicate user engagement, but it does not directly measure user satisfaction.

#Step 19 — Compare app size with installs
SELECT
    CASE
        WHEN Size_MB < 10 THEN 'Under 10 MB'
        WHEN Size_MB < 50 THEN '10–50 MB'
        ELSE '50 MB and above'
    END AS size_group,
    COUNT(*) AS total_apps,
    ROUND(AVG(Installs), 0) AS average_installs
FROM google_playstore
WHERE Size_MB IS NOT NULL
GROUP BY size_group
ORDER BY average_installs DESC;

#Business Insights: App Size vs. Installs
#1. Highest average installs: Apps sized 50 MB and above average approximately 12.93 million installs.
#2. Most common size group: Under 10 MB, with 5,020 apps.
#3. Lowest average installs: Apps sized 10–50 MB average approximately 4.15 million installs.
#4. Key insight: In this dataset, larger apps have higher average installs, but this does not prove that app size causes more downloads.

#Step 20 — Identify apps with the highest prices
SELECT
    App,
    Category,
    Price,
    Rating,
    Installs
FROM google_playstore
WHERE Type = 'Paid'
ORDER BY Price DESC
LIMIT 10;

#Business Insights: Most Expensive Paid Apps
#1. Highest price: “I'm Rich - Trump Edition” costs 400.00.
#2. Common pricing: Most of the top 10 apps are priced at 399.99.
#3. Category trend: FINANCE and FAMILY appear multiple times among the most expensive apps.
#4. Key insight: High-priced apps can have very different install counts, so price alone does not indicate popularity.

#Step 21 — Find the categories with the most reviews
SELECT
    Category,
    SUM(Reviews) AS total_reviews
FROM google_playstore
GROUP BY Category
ORDER BY total_reviews DESC
LIMIT 10;

#Business Insights: Categories with the Most Reviews
#1. Highest engagement: GAME leads with approximately 591 million reviews.
#2. Second place: COMMUNICATION has approximately 286 million reviews.
#3. Other major categories: TOOLS and SOCIAL also have over 227 million reviews each.
#4. Key insight: GAME attracts the most reviews, indicating substantial user engagement in this dataset.

#Step 22 — Analyse app rating distribution
SELECT
    CASE
        WHEN Rating < 3 THEN 'Below 3'
        WHEN Rating < 4 THEN '3 to below 4'
        ELSE '4 to 5'
    END AS rating_group,
    COUNT(*) AS total_apps
FROM google_playstore
WHERE Rating > 0
GROUP BY rating_group
ORDER BY total_apps DESC;

#Business Insights: App Rating Distribution
#1. Highest rating group: 6,287 apps have ratings from 4 to 5.
#2. Moderate ratings: 1,631 apps are rated from 3 to below 4.
#3. Low ratings: 278 apps have ratings below 3.
#4. Key insight: Most rated apps have a rating of at least 4, suggesting generally positive user feedback in this dataset.

#Step 23 — Analyse apps by last updated year
SELECT
    Update_Year,
    COUNT(*) AS total_apps
FROM google_playstore
WHERE Update_Year IS NOT NULL
GROUP BY Update_Year
ORDER BY Update_Year DESC;

#Business Insights: App Update Year
#1. Most recently updated: 6,287 apps were last updated in 2018.
#2. Older apps: Only 1 app was last updated in 2010.
#3. Trend: The number of apps updated declines substantially for earlier years.
#4. Key insight: Most apps in this dataset were last updated in 2017 or 2018, reflecting the dataset’s historical time period.
