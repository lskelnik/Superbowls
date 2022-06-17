# Superbowls
**Updated and built upon existing Superbowl dataset from DataCamp.  Analysis of the games, tv viewership, and halftime performers.**

Added data through Superbowl 56 (2022). Created primary and foreign key relationships. Created additional tables to include all of the NFL teams with a unique identifier and a corresponding table to separate each team into their division. This will be useful in the exploratory analysis to include the teams who have never been to the superbowl and to compare the appearances, wins, losses, etc. by team and division.

Analysis of the superbowl schema to compare superbowl totals and records by team, division, quarterback, and coach. View the superbowls with the highest average viewers and the smallest and largest point differential. See how many games were played at different venues, in each city, and the number of times they were broadcast on each network. Compare the ad cost trends and which musicians have performed at the most superbowls.
   
Skills used: Window functions, aggregate functions, mathematical functions, coalesce functions, joins, creating tables, updating tables, data cleaning, adding primary                keys and foreign key constraints.

**TV viewership data dictionary**

18–49 rating – the average percentage of adults age 18–49 in the United States with a television set who were watching the game at any given minute during its broadcast. For example, during the 2019–20 television season, a 1.0 18–49 rating was equivalent to approximately 1.28 million U.S. adults age 18–49.

18–49 share – the average percentage of adults age 18–49 in the United States with a television set in use who were watching the game at any given minute during its broadcast.

Average viewers – the average number of viewers who were watching the game at any given minute during its broadcast; the standard ratings measurement metric.

Household rating – the average percentage of households in the United States with a television set that were watching the game at any given minute during its broadcast. For example, during the 2019–20 television season, a 1.0 household rating was equivalent to approximately 1.21 million U.S. households.

Household share – the average percentage of households in the United States with a television set in use that were watching the game at any given minute during its broadcast.

Total viewers – the number of viewers in the United States who watched at least six minutes of the game during its broadcast (originally at least five minutes); not an industry-standard metric or usually reported outside of special event programming.

**Source and limitations of dataset**

Data scraped from Wikipedia. Backup quarterback column missing data, most likely because the majority of starting quarterbacks play the entire game. For the halftime musician data, there are missing values for numbers of songs performed (num_songs) for about a third of the performances. This may be due to this information not always being tracked. For the tv viewership data, total_us_viewers column is missing many values as well. Bottom line, the data source is good but not perfect. For these reasons, the aforementioned columns were not used in this analysis. 
