/* Build onto existing database by creating primary and foreign key relationships. Update each table
   to include data through Superbowl 56 (2022). Create two additional tables to include all of the NFL teams with 
   a unique identifier and a corresponding table to separate each team into their division. This will be useful in
   the exploratory analysis to include the teams who have never been to the superbowl and to compare the appearances,
   wins, losses, etc. by team and division.
*/

-- Add primary key to the super_bowl column (INT) in the game_details table. This column will not accept null values. 

ALTER TABLE game_details
CHANGE COLUMN super_bowl super_bowl INT NOT NULL,
ADD PRIMARY KEY (super_bowl);

-- Add foreign key to the super_bowl column in the halftime_musicians table. This column will not accept null values.

ALTER TABLE halftime_musicians 
CHANGE COLUMN super_bowl super_bowl INT NOT NULL,
ADD FOREIGN KEY (super_bowl)
  REFERENCES game_details (super_bowl)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

-- Add foreign key to the super_bowl column in the tv table. This column will not accept null values.

ALTER TABLE tv 
CHANGE COLUMN super_bowl super_bowl INT NOT NULL,
ADD FOREIGN KEY (super_bowl)
  REFERENCES game_details (super_bowl)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

-- Create a table to identify all of the teams in the nfl, with the format from existing database (city + team name). 
-- Later we will use this full list to see which teams have not had superbowl appearances. 

  CREATE TABLE IF NOT EXISTS teams
(
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(50) NOT NULL,
    home_city VARCHAR(50)
);

INSERT INTO teams (team_name, home_city)
VALUES
    ('Arizona Cardinals', 'Glendale'), ('Atlanta Falcons', 'Atlanta'), ('Baltimore Ravens', 'Baltimore'),
    ('Buffalo Bills', 'Orchard Park'), ('Carolina Panthers', 'Charlotte'), ('Chicago Bears', 'Chicago'),
    ('Cincinnati Bengals', 'Cincinnati'), ('Cleveland Browns', 'Cleveland'), ('Dallas Cowboys', 'Arlington'),
    ('Denver Broncos', 'Denver'), ('Detroit Lions', 'Detroit'), ('Green Bay Packers', 'Green Bay'),
    ('Houston Texans', 'Houston'), ('Indianapolis Colts', 'Indianapolis'), ('Jacksonville Jaguars', 'Jacksonville'),
    ('Kansas City Chiefs', 'Kansas City'), ('Las Vegas Raiders', 'Las Vegas'), ('Los Angeles Chargers', 'Carson'),
    ('Los Angeles Rams', 'Los Angeles'), ('Miami Dolphins', 'Miami Gardens'), ('Minnesota Vikings', 'Minneapolis'),
    ('New England Patriots', 'Foxborough'), ('New Orleans Saints', 'New Orleans'), ('New York Giants', 'East Rutherford'),
    ('New York Jets', 'East Rutherford'), ('Philadelphia Eagles', 'Philadelphia'), ('Pittsburgh Steelers', 'Pittsburgh'),
    ('San Francisco 49ers', 'Santa Clara'), ('Seattle Seahawks', 'Seattle'), ('Tampa Bay Buccaneers', 'Tampa'),
    ('Tennessee Titans', 'Nashville'), ('Washington Redskins', 'Landover');

-- Create a table to organize each team into their respective divisions
-- Set team_id as a foreign key referencing the teams table  

CREATE TABLE IF NOT EXISTS divisions
(
     team_id INT NOT NULL,
     division_name VARCHAR(50),
     FOREIGN KEY fk_divisions_teams (team_id)
     REFERENCES teams (team_id)
     ON UPDATE CASCADE
     ON DELETE NO ACTION
);

INSERT INTO divisions
VALUES 
    (1, 'NFC West'), (2, 'NFC South'), (3, 'AFC North'), (4, 'AFC East'),
    (5, 'NFC South'), (6, 'NFC North'), (7, 'AFC North'), (8, 'AFC North'), 
    (9, 'NFC East'), (10, 'AFC West'), (11, 'NFC North'), (12, 'NFC North'),
    (13, 'AFC South'), (14, 'AFC South'), (15, 'AFC South'), (16, 'AFC West'),
    (17, 'AFC West'), (18, 'AFC West'), (19, 'NFC West'), (20, 'AFC East'),
    (21, 'NFC North'), (22, 'AFC East'), (23, 'NFC South'), (24, 'NFC East'), 
    (25, 'AFC East'), (26, 'NFC East'), (27, 'AFC North'), (28, 'NFC West'),
    (29, 'NFC West'), (30, 'NFC South'), (31, 'AFC South'), (32, 'NFC East');
    
-- Show the alternate names for the Superdome venue in Louisiana

SELECT *
FROM game_details
WHERE venue LIKE '%Superdome%';

-- Change one row from 'Superdome' in the 'venue' column in game_details table to 'Louisiana Superdome' for naming consistency

UPDATE game_details
SET venue = 'Louisiana Superdome' 
WHERE venue = 'Superdome';

-- Add data for super bowl 53 into each table

INSERT INTO game_details        
VALUES (53, '2019-02-03', 'Mercedes-Benz Stadium', 'Atlanta', 'Georgia', 70081, 
        'New England Patriots', 13, 'Tom Brady', '', 'Bill Belichick', 'Los Angeles Rams', 
        3, 'Jared Goff', '', 'Sean McVay', 16, 10);

INSERT INTO halftime_musicians
VALUES (53, 'Maroon 5'),
       (53, 'Travis Scott'),
       (53, 'Big Boi');
       
INSERT INTO tv
VALUES (53, 'CBS', 98200000, 149000000, 41.1, 67, 31.0, 78, 5200000);

-- Add data for super bowl 54 into each table

INSERT INTO game_details        
VALUES (54, '2020-02-02', 'Hard Rock Stadium', 'Miami Gardens', 'Florida', 62417,
        'Kansas City Chiefs', 31, 'Patrick Mahomes', '', 'Andy Reid', 'San Francisco 49ers', 
        20, 'Jimmy Garoppolo', '', 'Kyle Shanahan', 51, 11);

INSERT INTO halftime_musicians
VALUES (54, 'Jennifer Lopez'),
       (54, 'Shakira'),
       (54, 'Bad Bunny'),
       (54, 'J Balvin');
       
INSERT INTO tv
VALUES (54, 'FOX', 99900000, 148500000, 41.6, 69, 30.1, 77, 5600000);

-- Add data for super bowl 55 into each table

INSERT INTO game_details        
VALUES (55, '2021-02-07', 'Raymond James Stadium', 'Tampa', 'Florida', 24835,
        'Tampa Bay Buccaneers', 31, 'Tom Brady', '', 'Bruce Arians', 'Kansas City Chiefs', 
        9, 'Patrick Mahomes', '', 'Andy Reid', 40, 22);

INSERT INTO halftime_musicians
VALUES (55, 'The Weeknd');

INSERT INTO tv
VALUES (55, 'CBS', 91600000, '', 38.2, 68, 26.5, 88, 5600000);

-- Change Fox network to all caps for naming convention consistency with other networks

UPDATE tv
SET network = 'FOX' WHERE network = 'Fox';

-- Add data for super bowl 56 into each table

INSERT INTO game_details        
VALUES (56, '2022-02-13', 'SoFi Stadium', 'Inglewood', 'California', 70048,
        'Los Angeles Rams', 23, 'Matthew Stafford', '', 'Sean McVay', 'Cincinnati Bengals', 
        20, 'Joe Burrow', '', 'Zac Taylor', 43, 3);

INSERT INTO halftime_musicians
VALUES (56, 'Dr. Dre'),
       (56, 'Snoop Dogg'),
       (56, 'Eminem'),
       (56, 'Mary J. Blige'),
       (56, 'Kendrick Lamar'),
       (56, '50 Cent');

INSERT INTO tv
VALUES (56, 'NBC', 99200000, '', 36.9, 72, 29.5, '', 5600000);

-- Create a scaled down copy of the game_details table. Update the names of teams who have played in 
-- more than one city so they reflect the current location for that team. This will allow us to
-- calculate total wins and losses for modern franchises by keeping the names consistent.

CREATE TABLE IF NOT EXISTS modern_game_details AS
SELECT 
    super_bowl,
    date,
    team_winner,
    team_loser
FROM game_details;

UPDATE modern_game_details
SET team_winner = 'Las Vegas Raiders'
WHERE team_winner = 'Los Angeles Raiders' OR team_winner = 'Oakland Raiders';

UPDATE modern_game_details
SET team_loser = 'Las Vegas Raiders'
WHERE team_loser = 'Los Angeles Raiders' OR team_loser = 'Oakland Raiders';

UPDATE modern_game_details
SET team_winner = 'Los Angeles Rams'
WHERE team_winner = 'St. Louis Rams';

UPDATE modern_game_details
SET team_loser = 'Los Angeles Rams'
WHERE team_loser = 'St. Louis Rams';

UPDATE modern_game_details
SET team_winner = 'Indianapolis Colts'
WHERE team_winner = 'Baltimore Colts';

UPDATE modern_game_details
SET team_loser = 'Indianapolis Colts'
WHERE team_loser = 'Baltimore Colts';

UPDATE modern_game_details
SET team_loser = 'Los Angeles Chargers'
WHERE team_loser = 'San Diego Chargers';







