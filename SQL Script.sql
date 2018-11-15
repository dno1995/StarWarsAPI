-- This query results in a table summarizing the box office takings for an individual film. 
-- Change the number in this variable to return the corresponding film attributes
SET @film = 8
;

SELECT 
    Title Film_Title
    , DAYNAME(bo1.BoxOfficeDay) Day
    , DATE_FORMAT(bo1.BoxOfficeDay, '%b. %e, %Y') Date
    , ROUND(bo1.GrossTakings) Gross_Takings
    , ROUND(((bo1.GrossTakings-bo2.GrossTakings)/bo2.GrossTakings)*100, 1) "%_Change_From_Prior_Day"
    , ROUND(((bo1.GrossTakings-bo3.GrossTakings)/bo3.GrossTakings)*100, 1) "%_Change_From_Last_Week"
    , bo1.TheaterCount Theater_count
    , ROUND(bo1.GrossTakings/bo1.TheaterCount) Avg_Takings_Per_Theater
    , ROUND(SUM(GrossDate)) Gross_To_Date
    , DATEDIFF(bo1.BoxOfficeDay, ReleaseDate)+1 Day_Number
    , CEILING((DATEDIFF(bo1.BoxOfficeDay, ReleaseDate)+1)/7) Week_Number
FROM Films f
	LEFT JOIN BoxOffice bo1
		ON f.FilmID=bo1.FilmID
	LEFT JOIN BoxOffice bo2
		ON bo1.BoxOfficeDay=DATE_ADD(bo2.BoxOfficeDay, INTERVAL 1 DAY)
	LEFT JOIN BoxOffice bo3
		ON bo1.BoxOfficeDay=DATE_ADD(bo3.BoxOfficeDay, INTERVAL 7 DAY)
	LEFT JOIN (
			SELECT 
				b.FilmID
				, b.BoxOfficeDay
                		, SUM(b.GrossTakings) GrossDate
			FROM BoxOffice b 
            GROUP BY b.FilmID, b.BoxOfficeday) ba
		ON bo1.BoxOfficeDay >= ba.BoxOfficeDay
GROUP BY 
	Title
    , f.FilmID
    , Date
HAVING FilmID = @Film
ORDER BY Day_Number
;


-- This query results in a table with all the Star Wars movies in a single table, starting with the most recent one.
SELECT 
    Title Film_Title
    , DAYNAME(bo1.BoxOfficeDay) Day
    , DATE_FORMAT(bo1.BoxOfficeDay, '%b. %e, %Y') Date
    , ROUND(bo1.GrossTakings) Gross_Takings
    , ROUND(((bo1.GrossTakings-bo2.GrossTakings)/bo2.GrossTakings)*100, 1) "%_Change_From_Prior_Day"
    , ROUND(((bo1.GrossTakings-bo3.GrossTakings)/bo3.GrossTakings)*100, 1) "%_Change_From_Last_Week"
    , bo1.TheaterCount Theater_count
    , ROUND(bo1.GrossTakings/bo1.TheaterCount) Avg_Takings_Per_Theater
    , ROUND(SUM(GrossDate)) Gross_To_Date
    , DATEDIFF(bo1.BoxOfficeDay, ReleaseDate)+1 Day_Number
    , CEILING((DATEDIFF(bo1.BoxOfficeDay, ReleaseDate)+1)/7) Week_Number
FROM Films f
	LEFT JOIN BoxOffice bo1
		ON f.FilmID=bo1.FilmID
	LEFT JOIN BoxOffice bo2
		ON bo1.BoxOfficeDay=DATE_ADD(bo2.BoxOfficeDay, INTERVAL 1 DAY)
	LEFT JOIN BoxOffice bo3
		ON bo1.BoxOfficeDay=DATE_ADD(bo3.BoxOfficeDay, INTERVAL 7 DAY)
	LEFT JOIN (
			SELECT 
				b.FilmID
				, b.BoxOfficeDay
                		, SUM(b.GrossTakings) GrossDate
			FROM BoxOffice b 
            GROUP BY b.FilmID, b.BoxOfficeday) ba
		ON bo1.BoxOfficeDay >= ba.BoxOfficeDay
GROUP BY 
    Title
    , f.FilmID
    , Date
ORDER BY f.filmID DESC, Day_Number
;
