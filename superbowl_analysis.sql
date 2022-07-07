/* Exploratory analysis of superbowl schema to compare superbowl totals and records by team, division, 
   quarterback, and coach. View the superbowls with the highest average viewers and the smallest and largest
   point differential. See how many games were played at different venues, in each city, and the number of times 
   they were broadcast on each network. Compare the ad cost trends and which musicians have performed at the most
   superbowls.
   
   Skills used: Window functions, aggregate functions, mathematical functions, coalesce functions, joins.
*/

-- Use window functions to show:
-- The number of superbowl wins for each team, in order from most to least
-- The number of superbowl losses for each team, in order from most to least

CREATE OR REPLACE VIEW lombardis_per_team AS
SELECT 
    super_bowl,
    date,
    team_winner AS team,
    COUNT(team_winner) OVER(PARTITION BY team_winner) AS lombardi_trophies
FROM modern_game_details
ORDER BY lombardi_trophies DESC, team_winner ASC, date ASC;

CREATE OR REPLACE VIEW losses_per_team AS
SELECT 
    super_bowl,
    date,
    team_loser AS losing_team,
    team_winner AS winning_team,
    COUNT(team_loser) OVER(PARTITION BY team_loser) AS superbowl_losses
FROM modern_game_details
ORDER BY superbowl_losses DESC, team_loser ASC, date ASC;

-- Use the previously created views for superbowl wins and losses to show 
-- the total wins, losses, and appearances for each team

CREATE OR REPLACE VIEW totals_by_team AS
SELECT 
    DISTINCT t.team_name AS team,
    COALESCE(lombardi_trophies, 0) AS lombardi_trophies,
    COALESCE(superbowl_losses, 0) AS superbowl_losses,
    COALESCE(lombardi_trophies + superbowl_losses, lombardi_trophies, superbowl_losses, 0) AS appearances
FROM teams t
LEFT JOIN losses_per_team lpt
    ON (t.team_name = lpt.team)
LEFT JOIN lombardis_per_team wpt
    ON (t.team_name = wpt.team)
ORDER BY lombardi_trophies DESC, appearances DESC;

-- Show the teams who have never won a superbowl

SELECT * 
FROM totals_by_team
WHERE lombardi_trophies = 0;

-- Compare the superbowl wins by team, broken out by division

CREATE OR REPLACE VIEW totals_by_division AS
SELECT 
    DISTINCT t.team_name AS team,
    d.division_name,
    COALESCE(lombardi_trophies, 0) AS lombardi_trophies,
    COALESCE(superbowl_losses, 0) AS superbowl_losses,
    COALESCE(lombardi_trophies + superbowl_losses, lombardi_trophies, superbowl_losses, 0) AS appearances
FROM teams t
JOIN divisions d
    USING (team_id)
LEFT JOIN losses_per_team lpt
    ON (t.team_name = lpt.team)
LEFT JOIN lombardis_per_team wpt
    ON (t.team_name = wpt.team)
ORDER BY division_name ASC, lombardi_trophies DESC, appearances DESC;

-- Compare the quarterbacks with the most superbowl wins and the details of those games

CREATE OR REPLACE VIEW rings_per_quarterback AS
SELECT
    qb_winner_1 AS quarterback,
    COUNT(qb_winner_1) OVER(PARTITION BY qb_winner_1) AS number_of_rings,
    super_bowl,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts
FROM game_details
ORDER BY number_of_rings DESC, qb_winner_1 ASC, super_bowl ASC;

-- Compare the quarterbacks who have lost the most superbowls and show the details of those games

CREATE OR REPLACE VIEW losses_per_quarterback AS
SELECT
    qb_loser_1 AS quarterback,
    COUNT(qb_loser_1) OVER(PARTITION BY qb_loser_1) AS superbowls_lost,
    super_bowl,
    team_loser,
    losing_pts,
    team_winner,
    winning_pts
FROM game_details
ORDER BY superbowls_lost DESC, qb_loser_1 ASC, super_bowl ASC;

-- Show the totals by quarterback for superbowl wins, losses, appearances, and winning percentage

CREATE OR REPLACE VIEW totals_by_quarterback AS
SELECT 
    DISTINCT quarterback,
    number_of_rings,
    COALESCE(superbowls_lost, 0) AS superbowls_lost,
    COALESCE(number_of_rings + superbowls_lost, number_of_rings) AS appearances,
    ROUND(COALESCE(number_of_rings / (number_of_rings + superbowls_lost), 1.000), 3) AS winning_pct
FROM rings_per_quarterback
LEFT JOIN losses_per_quarterback
    USING (quarterback)
ORDER BY number_of_rings DESC, appearances DESC, winning_pct DESC;

-- Compare head coaches by number of superbowl rings, and include the details of each game

CREATE OR REPLACE VIEW rings_per_coach AS
SELECT
    coach_winner AS head_coach,
    COUNT(coach_winner) OVER(PARTITION BY coach_winner) AS number_of_rings,
    super_bowl,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts
FROM game_details
ORDER BY number_of_rings DESC, coach_winner ASC, super_bowl ASC;

-- Compare head coaches by number of superbowl losses, and include the details of each game

CREATE OR REPLACE VIEW losses_per_coach AS
SELECT
    coach_loser AS head_coach,
    COUNT(coach_loser) OVER(PARTITION BY coach_loser) AS superbowls_lost,
    super_bowl,
    team_loser,
    losing_pts,
    team_winner,
    winning_pts
FROM game_details
ORDER BY superbowls_lost DESC, coach_loser ASC, super_bowl ASC;

-- View the superbowl records by coach. Include total wins, losses, appearances, and winning pct.

CREATE OR REPLACE VIEW totals_by_coach AS
SELECT 
    DISTINCT head_coach,
    number_of_rings,
    COALESCE(superbowls_lost, 0) AS superbowls_lost,
    COALESCE(number_of_rings + superbowls_lost, number_of_rings) AS appearances,
    ROUND(COALESCE(number_of_rings / (number_of_rings + superbowls_lost), 1.000), 3) AS winning_pct
FROM rings_per_coach
LEFT JOIN losses_per_coach
    USING (head_coach)
ORDER BY number_of_rings DESC, appearances DESC, winning_pct DESC;

-- Compare the superbowl wins by conference (AFC vs NFC)

CREATE OR REPLACE VIEW superbowls_by_conference AS
SELECT 
    (SELECT
        SUM(lombardi_trophies)
        FROM totals_by_division
        WHERE division_name LIKE '%AFC%') AS afc_wins,
    (SELECT
        SUM(lombardi_trophies)
        FROM totals_by_division
        WHERE division_name LIKE '%NFC%') AS nfc_wins;
        
-- Show the total broadcast count for each network

CREATE OR REPLACE VIEW games_by_network AS
SELECT
    network,
    COUNT(network) AS number_broadcasts
FROM tv
GROUP BY network
ORDER BY number_broadcasts DESC;

-- Show all musicians who performed in more than one superbowl

CREATE OR REPLACE VIEW multiple_appearance_musicians AS
SELECT
    musician,
    COUNT(musician) number_appearances
FROM halftime_musicians
GROUP BY musician
HAVING number_appearances >= 2
ORDER BY number_appearances DESC;

-- Show how many times each venue has hosted the superbowl

CREATE OR REPLACE VIEW games_by_venue AS
SELECT 
    venue,
    COUNT(venue) AS super_bowls_hosted,
    city,
    state
FROM game_details
GROUP BY venue
ORDER BY super_bowls_hosted DESC, venue ASC;

-- Create a window function to show the details and count of superbowls hosted by each city

CREATE OR REPLACE VIEW games_by_city AS
SELECT 
    super_bowl,
    venue,
    city,
    state,
    COUNT(city) OVER(PARTITION BY venue) AS super_bowls_hosted
FROM game_details
ORDER BY city ASC, super_bowls_hosted DESC,  super_bowl ASC;

-- Create a view of the top ten rated superbowls based on average tv viewers

CREATE OR REPLACE VIEW top_ten_viewed AS
SELECT 
    super_bowl,
    date,
    avg_us_viewers,
    network,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts
FROM game_details
JOIN tv 
    USING (super_bowl)
ORDER BY avg_us_viewers DESC
LIMIT 10;

-- Rank all superbowls by their average tv viewers

CREATE OR REPLACE VIEW rank_by_viewers AS
SELECT 
    super_bowl,
    date,
    avg_us_viewers,
    network,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts
FROM game_details
JOIN tv 
    USING (super_bowl)
ORDER BY avg_us_viewers DESC;

-- Show the changes in ad cost by year

CREATE OR REPLACE VIEW ad_cost_trend AS
SELECT 
    super_bowl,
    date,
    ad_cost
FROM game_details
JOIN tv 
    USING (super_bowl)
ORDER BY super_bowl ASC;

-- Rank the top ten games with the largest point differential

CREATE OR REPLACE VIEW top_ten_blowouts AS
SELECT
    super_bowl,
    date,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts,
    difference_pts,
    qb_winner_1,
    qb_loser_1,
    coach_winner,
    coach_loser
FROM game_details
ORDER BY difference_pts DESC
LIMIT 10;

-- Rank the top ten games with the smallest point differential

CREATE OR REPLACE VIEW ten_closest_games AS
SELECT
    super_bowl,
    date,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts,
    difference_pts,
    qb_winner_1,
    qb_loser_1,
    coach_winner,
    coach_loser
FROM game_details
ORDER BY difference_pts ASC, combined_pts DESC
LIMIT 10;

CREATE OR REPLACE VIEW game_scores AS
SELECT
    super_bowl,
    date,
    team_winner,
    winning_pts,
    team_loser,
    losing_pts,
    city,
    state,
    venue,
    attendance
FROM game_details;
