Movie Contest
=========

This is a Ruby on Rails app based on [Brian Brushwood] and [Justin Robert Young]'s Movie Draft, originally conceived on the [TWiT.tv] Network. While their format is run like a auction draft, this is more of a movie "stock market".

Gameplay
--
The game will run during the summer and winter movie seasons. Summer typically runs from April to August, and winter runs from November to the end of December. There are two phases, a purchasing phase and an accrual phase.

### Purchasing
A list of 20-30 movies will be selected and will be placed into a form. The list of movies should total about 20-30, and all should have at least a wide release. This form will list the movies linked to their [IMDB] page, the synopsis from IMDB, at last two actors/actresses, and a textbox for how many shares the player would like to put on the movie.

Players will receive 100 fake dollars to buy shares of movies that are listed on the form, at $1 per share. The total number shares purchased by the player must not exceed 100. The deadline to submit the form is whenever the first movie comes out. Only a player's most recent submission will be scored. After this deadline, the shares form may no longer be submitted and the accrual phase begins.

### Accrual
Once the movies on the list begin to debut, the players begin to accrue their score, based on how much they bid on the movies. Whatever percentage of the shares for a movie a player owns, the player gets that percentage of the movie's total domestic revenue. This happens for each movie where the player owns at least one share. This is a continuous process of money accrual, continuing until four weeks after the last movie is released. At this point, the player with the most money is the winner.

Example
--
Let's say *Rocky VI* is coming out this summer, and it winds up making $180,000,000. This is what the following players will get, based on their bids:

| Player        | Shares        | Score          |
| ------------- |:-------------:| --------------:|
| Alice         | 5             | $45,000,000    |
| Bob           | 10            | $90,000,000    |
| Charlie       | 0             | $0             |
| David         | 3             | $27,000,000    |
| Eve           | 7             | $63,000,000    |
|**TOTAL**      |**20**         |**$180,000,000**|

Repeat this for each movie, and the sum for each player will be their current score.

[Brian Brushwood]:http://www.twitter.com/shwood
[Justin Robert Young]:http://www.twitter.com/justinryoung
[TWiT.tv]:http://www.twit.tv
[IMDB]:http://www.imdb.com