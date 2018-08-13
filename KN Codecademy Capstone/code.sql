/*
These queries show us the number of distinct campaigns, as well as the sources per campaign.
*/
SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;
    
SELECT COUNT (DISTINCT utm_source) AS 'Source Count'
FROM page_visits;
   
SELECT COUNT(DISTINCT utm_campaign) AS 'Distinct Campaigns', COUNT(DISTINCT utm_source) AS 'Distinct Source'
FROM page_visits;

SELECT DISTINCT utm_campaign AS 'Campaign'
, utm_source AS 'Source'
FROM page_visits;

SELECT DISTINCT page_name AS 'Page Name'
FROM page_visits;

/*First Touch Attribution Query*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS(
	SELECT ft.user_id,
    		 ft.first_touch_at,
    		 pv.utm_source,
         pv.utm_campaign
	FROM first_touch ft
	JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS Source,
			 ft_attr.utm_campaign AS Campaign,
       COUNT (*) AS COUNT
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*Last Touch Attribution Query*/

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
			 lt.last_touch_at,
  		 pv.utm_source,
    	 pv.utm_campaign,
  		 pv.page_name
FROM last_touch lt
JOIN page_visits pv
	ON lt.user_id = pv.user_id
  AND lt.last_touch_at = pv.timestamp
  )
  SELECT lt_attr.utm_source AS Source,
  			 lt_attr.utm_campaign AS Campaign,
         COUNT(*)
 FROM lt_attr
 GROUP by 1, 2
 ORDER BY 3 DESC;
 
 /*This query shows us how many people customers made it to the purchase page*/
 
 SELECT COUNT(DISTINCT user_id) AS 'Customers'
 FROM page_visits
 WHERE page_name = '4 - purchase';
 
 /*This query below generates a table showing purchases by campaign */
 
 WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
ft_attr AS (
  SELECT lt.user_id,
  			 lt.last_touch_at,
  			 pv.utm_source,
  			 pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
  	ON lt.user_id = pv.user_id
  	AND lt.last_touch_at = pv.timestamp
  )
  SELECT ft_attr.utm_source AS Source,
  			 ft_attr.utm_campaign AS Campaign,
         COUNT(*) AS COUNT
  FROM ft_attr
  GROUP BY 1, 2
  ORDER BY 3 DESC;