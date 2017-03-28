class AddMoviesForSummer2017 < ActiveRecord::Migration
def change
    reversible do |dir|
      dir.up do
        season = Season.create(name:'Summer 2017', page_title:'Fantasy Movie League | Summer 2017', slug:'2017s', bonus_amount: 5000000, new_header_content:'')
        
        Team.create(name:'Friends', slug:'friends', season_id: season.id)
        Team.create(name:'DealerOn', slug:'dealeron', season_id: season.id)
        Team.create(name:'Urban Science', slug:'urban-science', season_id: season.id)

        Movie.create(name:'Guardians of the Galaxy Vol. 2',
          plot:'The team continues their adventures as they unravel the mystery of Peter Quill\'s true parentage.',
          actors:'Chris Pratt, Kurt Russell, Bradley Cooper, Zoe Saldana',
          release_date:'2017-05-05T05:00:00Z',
          director:'James Gunn',
          imdb: 'http://www.imdb.com/title/tt3896198',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/guardians_of_the_galaxy_vol_2',
          season_id: season.id)
          
        Movie.create(name:'King Arthur: Legend of the Sword',
          plot:'Once Arthur pulls the sword from the stone, he is forced to acknowledge his true legacy - whether he likes it or not.',
          actors:'Charlie Hunnam, Katie McGrath, Jude Law',
          release_date:'2017-05-12T05:00:00Z',
          director:'Guy Ritchie',
          imdb: 'http://www.imdb.com/title/tt1972591',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/king_arthur_legend_of_the_sword',
          season_id: season.id)
          
        Movie.create(name:'Snatched',
          plot:'After her boyfriend dumps her on the eve of their exotic vacation, impetuous dreamer Emily persuades her ultra-cautious mother to travel with her to paradise.',
          actors:'Amy Schumer, Goldie Hawn',
          release_date:'2017-05-12T05:00:00Z',
          director:'Jonathan Levine',
          imdb: 'http://www.imdb.com/title/tt2334871',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/snatched_2017',
          season_id: season.id)
          
        Movie.create(name:'Alien: Covenant',
          plot:'The crew of a colony ship discover an uncharted paradise, with a threat beyond their imagination, and must attempt a harrowing escape.',
          actors:'Katherine Waterston, Michael Fassbender, Noomi Rapace',
          release_date:'2017-05-19T05:00:00Z',
          director:'Ridley Scott',
          imdb: 'http://www.imdb.com/title/tt2316204',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/alien_covenant',
          season_id: season.id)
          
        Movie.create(name:'Everything, Everything',
          plot:'A teenager who\'s lived a sheltered life because she\'s allergic to everything, falls for the boy who moves in next door.',
          actors:'Amanda Stenberg, Nick Robinson',
          release_date:'2017-05-19T05:00:00Z',
          director:'Stella Meghie',
          imdb: 'http://www.imdb.com/title/tt5001718',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/everything_everything_2017',
          season_id: season.id)
          
        Movie.create(name:'Baywatch',
          plot:'A devoted lifeguard and a brash new recruit uncover a local criminal plot that threatens the future of the Bay.',
          actors:'Dwayne Johnson, Zac Efron, Alexandra Daddario',
          release_date:'2017-05-26T05:00:00Z',
          director:'Seth Gordon',
          imdb: 'http://www.imdb.com/title/tt1469304',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/baywatch_2017',
          season_id: season.id)
          
        Movie.create(name:'Pirates of the Caribbean: Dead Men Tell No Tales',
          plot:'Captain Jack Sparrow searches for the trident of Poseidon.',
          actors:'Johnny Depp, Orlando Bloom, Kaya Scodelario',
          release_date:'2017-05-26T05:00:00Z',
          director:'Joachim Rønning, Espen Sandberg',
          imdb: 'http://www.imdb.com/title/tt1790809',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/pirates_of_the_caribbean_dead_men_tell_no_tales',
          season_id: season.id)
          
        Movie.create(name:'Captain Underpants',
          plot:'Two mischievous kids hypnotize their mean elementary school principal and turn him into their comic book creation.',
          actors:'Jordan Peele, Nick Kroll, Ed Helms',
          release_date:'2017-06-02T05:00:00Z',
          director:'David Soren',
          imdb: 'http://www.imdb.com/title/tt2091256',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/captain_underpants_the_first_epic_movie',
          season_id: season.id)
          
        Movie.create(name:'Wonder Woman',
          plot:'An Amazon princess leaves her island home to explore the world and, in doing so, becomes one of the world\'s greatest heroes.',
          actors:'Gal Gadot, Chris Pine',
          release_date:'2017-06-02T05:00:00Z',
          director:'Patty Jenkins',
          imdb: 'http://www.imdb.com/title/tt0451279',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/wonder_woman_2017',
          season_id: season.id)
          
        Movie.create(name:'It Comes at Night',
          plot:'A man\'s security in a desolate home is put to the test as an unknown threat terrorizes the world.',
          actors:'Joel Edgerton, Riley Keough',
          release_date:'2017-06-09T05:00:00Z',
          director:'Trey Edward Shults',
          imdb: 'http://www.imdb.com/title/tt4695012',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/it_comes_at_night',
          season_id: season.id)
          
        Movie.create(name:'The Mummy',
          plot:'An ancient princess is awakened from her crypt beneath the desert, bringing with her terrors that defy human comprehension.',
          actors:'Sofia Boutella, Tom Cruise, Russell Crowe',
          release_date:'2017-06-09T05:00:00Z',
          director:'Alex Kurtzman',
          imdb: 'http://www.imdb.com/title/tt2345759',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/the_mummy_2017',
          season_id: season.id)
          
        Movie.create(name:'All Eyez on Me',
          plot:'A chronicle of the life of rapper Tupac Shakur.',
          actors:'Demetrius Shipp Jr.',
          release_date:'2017-06-16T05:00:00Z',
          director:'Benny Boom',
          imdb: 'http://www.imdb.com/title/tt1666185',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/all_eyez_on_me_2017',
          season_id: season.id)
          
        Movie.create(name:'Cars 3',
          plot:'Lightning McQueen sets out to prove to a new generation of racers that he\'s still the best race car in the world.',
          actors:'Armie Hammer, Owen Wilson, Nathan Fillion',
          release_date:'2017-06-16T05:00:00Z',
          director:'Brian Fee',
          imdb: 'http://www.imdb.com/title/tt3606752',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/cars_3_2017',
          season_id: season.id)
          
        Movie.create(name:'Rough Night',
          plot:'A male stripper ends up dead at a Miami beach house during a bachelorette party weekend.',
          actors:'Scarlett Johansson, Zoe Kravitz, Kate McKinnon',
          release_date:'2017-06-16T05:00:00Z',
          director:'Lucia Aniello',
          imdb: 'http://www.imdb.com/title/tt4799050',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/rough_night',
          season_id: season.id)
          
        Movie.create(name:'Transformers: The Last Knight',
          plot:'The key to saving humanity\'s future lies buried in the secrets of the past, in the hidden history of Transformers on Earth.',
          actors:'Mark Wahlberg, Anthony Hopkins',
          release_date:'2017-06-23T05:00:00Z',
          director:'Michael Bay',
          imdb: 'http://www.imdb.com/title/tt3371366',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/transformers_the_last_knight_2017',
          season_id: season.id)
          
        Movie.create(name:'Despicable Me 3',
          plot:'Balthazar Bratt, a child star from the 1980s, hatches a scheme for world domination.',
          actors:'Kristen Wiig, Steve Carrell, Jenny Slate',
          release_date:'2017-06-23T05:00:00Z',
          director:'Kyle Balda, Pierre Coffin',
          imdb: 'http://www.imdb.com/title/tt3469046',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/despicable_me_3',
          season_id: season.id)
          
        Movie.create(name:'The House',
          plot:'A dad convinces his friends to start an illegal casino in his basement after he and his wife spend their daughter\'s college fund.',
          actors:'Will Ferrell, Amy Poehler',
          release_date:'2017-06-23T05:00:00Z',
          director:'Andrew J. Cohen',
          imdb: 'http://www.imdb.com/title/tt4481514',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/the_house_2017',
          season_id: season.id)
          
        Movie.create(name:'Spider-Man: Homecoming',
          plot:'Peter Parker attempts to balance his life in high school with his career as the web-slinging superhero Spider-Man.',
          actors:'Tom Holland, Marisa Tomei, Donald Glover',
          release_date:'2017-07-07T05:00:00Z',
          director:'Jon Watts',
          imdb: 'http://www.imdb.com/title/tt2250912',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/spider_man_homecoming',
          season_id: season.id)
          
        Movie.create(name:'War for the Planet of the Apes',
          plot:'A nation of genetically evolved apes becomes embroiled in a battle with an army of humans.',
          actors:'Woody Harrelson, Judy Greer, Andy Serkis',
          release_date:'2017-07-14T05:00:00Z',
          director:'Matt Reeves',
          imdb: 'http://www.imdb.com/title/tt3450958',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/war_for_the_planet_of_the_apes',
          season_id: season.id)
          
        Movie.create(name:'Dunkirk',
          plot:'Allied soldiers are surrounded by the German army and evacuated during a fierce battle in World War II.',
          actors:'Tom Hardy, Cillian Murphy',
          release_date:'2017-07-21T05:00:00Z',
          director:'Christopher Nolan',
          imdb: 'http://www.imdb.com/title/tt5013056',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/dunkirk_2017',
          season_id: season.id)
          
        Movie.create(name:'Atomic Blonde',
          plot:'An undercover MI6 agent is sent to Berlin during the Cold War to investigate the murder of a fellow agent.',
          actors:'Charlize Theron, James McAvoy',
          release_date:'2017-07-28T05:00:00Z',
          director:'David Leitch',
          imdb: 'http://www.imdb.com/title/tt2406566',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/atomic_blonde_2017',
          season_id: season.id)
          
        Movie.create(name:'The Dark Tower',
          plot:'Roland Deschain searches for the fabled Dark Tower, in the hopes that reaching it will preserve his dying world.',
          actors:'Idris Elba, Katheryn Winnick, Matthew McConaughey',
          release_date:'2017-07-28T05:00:00Z',
          director:'Nikolaj Arcel',
          imdb: 'http://www.imdb.com/title/tt1648190',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/the_dark_tower_2017',
          season_id: season.id)
          
        Movie.create(name:'An Inconvenient Sequel',
          plot:'A follow-up documentary to An Inconvenient Truth showing just how close we are to an energy revolution.',
          actors:'Al Gore',
          release_date:'2017-07-28T05:00:00Z',
          director:'Bonni Cohen, Jon Shenk',
          imdb: 'http://www.imdb.com/title/tt6322922',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/an_inconvenient_sequel_truth_to_power',
          season_id: season.id)
          
        Movie.create(name:'The Emoji Movie',
          plot:'Gene, a multi-expressional emoji, sets out on a journey to become a normal emoji.',
          actors:'T.J. Miller, Maya Rudolph, Patrick Stewart',
          release_date:'2017-08-04T05:00:00Z',
          director:'Tony Leondis',
          imdb: 'http://www.imdb.com/title/tt4877122',
          rotten_tomatoes_url:'https://www.rottentomatoes.com/m/the_emoji_movie',
          season_id: season.id)
          
      end
      dir.down do
        season = Season.where(name:'Summer 2017').first
        Movie.where(season_id: season.id).destroy_all
      end
    end
  end
end
