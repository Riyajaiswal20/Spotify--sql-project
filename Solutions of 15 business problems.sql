---Solutions of 15 business problems
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where stream > 1000000000

--2. List all albums along with their respective artists
select distinct album,artist
from spotify
order by 1

  --3.Get the total number of comments for tracks where licensed = TRUE.
  SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;

--4.Find all tracks that belong to the album type single.
SELECT track
FROM spotify
WHERE album_type ILIKE 'single';


--5. Count the total number of tracks by each artist.
SELECT artist, COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks DESC;

--6. Calculate the average danceability of tracks in each album.
SELECT album, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;

--7. Find the top 5 tracks with the highest energy values.
SELECT track, energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

--8. List all tracks along with their views and likes where official_video = TRUE.
SELECT track, views, likes
FROM spotify
WHERE official_video = TRUE
ORDER BY views DESC;

--9. For each album, calculate the total views of all associated tracks.
SELECT album, SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC

--10 . Retrieve the track names that have been streamed more on Spotify than on YouTube.
SELECT track
FROM spotify
WHERE most_played_on = 'Spotify';

--11. Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist AS (
    SELECT
        artist,
        track,
        SUM(views) AS total_view,
        DENSE_RANK() OVER (
            PARTITION BY artist
            ORDER BY SUM(views) DESC
        ) AS rank
    FROM spotify
    GROUP BY artist, track
)
SELECT *
FROM ranking_artist
WHERE rank <= 3
ORDER BY artist, total_view DESC;

--12. Write a query to find tracks where the liveness score is above the average.
SELECT track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC;

--13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC

--14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT track, energy, liveness,
       (energy / NULLIF(liveness, 0)) AS energy_liveness_ratio
FROM spotify
WHERE (energy / NULLIF(liveness, 0)) > 1.2;

--15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT track, views, likes,
       SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM spotify;












