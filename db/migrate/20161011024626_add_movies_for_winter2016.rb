class AddMoviesForWinter2016 < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        season = Season.create(name:'Winter 2016', page_title:'Fantasy Movie League | Winter 2016', slug:'2016w', bonus_amount: 5000000, new_header_content:'')
        
        Team.create(name:'Friends', slug:'friends', season_id: season.id)
        Team.create(name:'DealerOn', slug:'dealeron', season_id: season.id)
        Team.create(name:'Urban Science', slug:'urban-science', season_id: season.id)

        Movie.create(name:'Doctor Strange',
          plot:'A neurosurgeon with a destroyed career sets out to repair his hands only to find himself protecting the world from inter-dimensional threats.',
          actors:'Benedict Cumberbatch, Rachel McAdams, Tilda Swinton',
          release_date:'2016-11-04T04:00:00Z',
          director:'Scott Derrickson',
          imdb: 'http://www.imdb.com/title/tt1211837',
          rotten_tomatoes_id:'771385622',
          season_id: season.id)
        Movie.create(name:'Hacksaw Ridge',
          plot:'Based on the true story about US Army medic Desmond T. Doss, a conscientious objector who refused to bear arms, yet was awarded the Medal of Honor for single-handedly saving the lives of over 75 of his comrades.',
          actors:'Andrew Garfield, Sam Worthington',
          release_date:'2016-11-04T04:00:00Z',
          director:'Mel Gibson',
          imdb: 'http://www.imdb.com/title/tt2119532',
          rotten_tomatoes_id:'771419799',
          season_id: season.id)
        Movie.create(name:'Trolls',
          plot:'A grumpy troll survivalist named Branch goes along with giddy Poppy on a quest to save Troll Town\'s population.',
          actors:'Anna Kendrick, Justin Timberlake, Gwen Stefani',
          release_date:'2016-11-04T05:00:00Z',
          director:'Mike Mitchell, Walt Dohrn',
          imdb: 'http://www.imdb.com/title/tt1679335',
          rotten_tomatoes_id:'771315649',
          season_id: season.id)
        Movie.create(name:'Arrival',
          plot:'A linguist is recruited by the military to assist in translating alien communications.',
          actors:'Amy Adams, Jeremy Renner',
          release_date:'2016-11-11T05:00:00Z',
          director:'Dennis Villeneuve',
          imdb: 'http://www.imdb.com/title/tt2543164',
          rotten_tomatoes_id:'771445196',
          season_id: season.id)
        Movie.create(name:'Billy Lynn\'s Long Halftime Walk',
          plot:'19-year-old Billy Lynn is brought home for a victory tour after a harrowing Iraq battle.',
          actors:'Kristen Stewart, Joe Alwyn, Vin Diesel, Steve Martin',
          release_date:'2016-11-11T05:00:00Z',
          director:'Ang Lee',
          imdb: 'http://www.imdb.com/title/tt2513074',
          rotten_tomatoes_id:'771417392',
          season_id: season.id)
        Movie.create(name:'Fantastic Beasts and Where to Find Them',
          plot:'The adventures of writer Newt Scamander in New York\'s secret community of witches and wizards seventy years before Harry Potter reads his book in school.',
          actors:'Eddie Redmayne, Ezra Miller',
          release_date:'2016-11-18T05:00:00Z',
          director:'David Yates',
          imdb: 'http://www.imdb.com/title/tt3183660',
          rotten_tomatoes_id:'771364505',
          season_id: season.id)
        Movie.create(name:'The Edge of Seventeen',
          plot:'High-school life gets even more unbearable for Nadine when her best friend, Krista, starts dating her older brother.',
          actors:'Hailee Steinfeld, Haley Lu Richardson',
          release_date:'2016-11-18T05:00:00Z',
          director:'Kelly Fremon Craig',
          imdb: 'http://www.imdb.com/title/tt1878870',
          rotten_tomatoes_id:'771436167',
          season_id: season.id)
        Movie.create(name:'Moana',
          plot:'A young woman uses her navigational talents to set sail for a fabled island. ',
          actors:'Dwayne Johnson, Auli\'i Cravalho, Alan Tudyk',
          release_date:'2016-11-25T05:00:00Z',
          director:'Don Clements, John Musker, Don Hall, Chris Williams',
          imdb: 'http://www.imdb.com/title/tt3521164',
          rotten_tomatoes_id:'771400848',
          season_id: season.id)
        Movie.create(name:'Allied',
          plot:'In 1942, an intelligence officer in North Africa encounters a female French Resistance fighter on a deadly mission behind enemy lines. When they reunite in London, their relationship is tested by the pressures of war.',
          actors:'Brad Pitt, Marion Cotillard',
          release_date:'2016-11-25T05:00:00Z',
          director:'Robert Zemeckis',
          imdb: 'http://www.imdb.com/title/tt3640424',
          rotten_tomatoes_id:'771441346',
          season_id: season.id)
        Movie.create(name:'Rules Don\'t Apply',
          plot:'An unconventional love story of an aspiring actress, her determined driver, and the eccentric billionaire who they work for.',
          actors:'Haley Bennett, Lily Collins',
          release_date:'2016-11-25T05:00:00Z',
          director:'Warren Beatty',
          imdb: 'http://www.imdb.com/title/tt1974420',
          rotten_tomatoes_id:'771443706',
          season_id: season.id)
        Movie.create(name:'Kidnap',
          plot:'A mother stops at nothing to recover her kidnapped son.',
          actors:'Halle Berry',
          release_date:'2016-12-02T05:00:00Z',
          director:'Luis Prieto',
          imdb: 'http://www.imdb.com/title/tt1458169',
          rotten_tomatoes_id:'771390116',
          season_id: season.id)
        Movie.create(name:'La La Land',
          plot:'A jazz pianist falls for an aspiring actress in Los Angeles.',
          actors:'Ryan Gosling, Emma Stone',
          release_date:'2016-12-09T05:00:00Z',
          director:'Damien Chazelle',
          imdb: 'http://www.imdb.com/title/tt3783958',
          rotten_tomatoes_id:'771418254',
          season_id: season.id)
        Movie.create(name:'Office Christmas Party',
          plot:'When his branch is threatened to be closed, a manager throws an epic Christmas party in order to land a big client and save the day, but the party gets way out of hand.',
          actors:'Jennifer Aniston, Jason Bateman, Kate McKinnon',
          release_date:'2016-12-09T05:00:00Z',
          director:'Josh Gordon, Will Speck',
          imdb: 'http://www.imdb.com/title/tt1711525',
          rotten_tomatoes_id:'771438232',
          season_id: season.id)
        Movie.create(name:'Miss Sloane',
          plot:'An ambitious lobbyist faces off against the powerful gun lobby in an attempt to pass gun control legislation.',
          actors:'Jessica Chastain, Gugu Mbatha-Raw',
          release_date:'2016-12-09T05:00:00Z',
          director:'John Madden',
          imdb: 'http://www.imdb.com/title/tt4540710',
          rotten_tomatoes_id:'771438126',
          season_id: season.id)
        Movie.create(name:'Rogue One: A Star Wars Story',
          plot:'The Rebellion makes a risky move to steal the plans to the Death Star, setting up the epic saga to follow.',
          actors:'Riz Ahmed, Ben Mendelsohn, Felicity Jones',
          release_date:'2016-12-16T05:00:00Z',
          director:'Gareth Edwards',
          imdb: 'http://www.imdb.com/title/tt3748528',
          rotten_tomatoes_id:'771415158',
          season_id: season.id)
        Movie.create(name:'Collateral Beauty',
          plot:'A tragic event sends a New York ad man on a downward spiral.',
          actors:'Will Smith, Keira Knightley, Naomie Harris',
          release_date:'2016-12-16T05:00:00Z',
          director:'David Frankel',
          imdb: 'http://www.imdb.com/title/tt4682786',
          rotten_tomatoes_id:'771437625',
          season_id: season.id)
        Movie.create(name:'Passengers',
          plot:'A spacecraft traveling to a distant colony planet has a malfunction in its sleep chambers causing two passengers to be awakened 90 years early.',
          actors:'Jennifer Lawrence, Chris Pratt',
          release_date:'2016-12-21T05:00:00Z',
          director:'Morten Tyldum',
          imdb: 'http://www.imdb.com/title/tt1355644',
          rotten_tomatoes_id:'771357251',
          season_id: season.id)
        Movie.create(name:'Sing',
          plot:'A koala named Buster recruits his best friend to help him drum up business for his theater by hosting a singing competition.',
          actors:'Scarlett Johannson, Matthew McConaughey, Reese Witherspoon',
          release_date:'2016-12-21T05:00:00Z',
          director:'Garth Jennings',
          imdb: 'http://www.imdb.com/title/tt3470600',
          rotten_tomatoes_id:'771434221',
          season_id: season.id)
        Movie.create(name:'Assassin\'s Creed',
          plot:'When Callum Lynch explores the memories of his ancestor Aguilar and gains the skills of a Master Assassin, he discovers he is a descendant of the secret Assassins society.',
          actors:'Michael Fassbender, Michael Kenneth Williams',
          release_date:'2016-12-21T05:00:00Z',
          director:'Justin Kurzel',
          imdb: 'http://www.imdb.com/title/tt2094766',
          rotten_tomatoes_id:'771311901',
          season_id: season.id)
        Movie.create(name:'Fences',
          plot:'An African American father struggles with race relations in the United States while trying to raise his family in the 1950s and coming to terms with the events of his life.',
          actors:'Denzel Washington, Viola Davis',
          release_date:'2016-12-25T05:00:00Z',
          director:'Denzel Washington',
          imdb: 'http://www.imdb.com/title/tt2671706',
          rotten_tomatoes_id:'771441788',
          season_id: season.id)
        Movie.create(name:'Gold',
          plot:'An unlikely pair venture to the Indonesian jungle in search of gold.',
          actors:'Bryce Dallas Howard, Matthew McConaughey',
          release_date:'2016-12-25T05:00:00Z',
          director:'Stephen Gaghan',
          imdb: 'http://www.imdb.com/title/tt1800302',
          rotten_tomatoes_id:'771426863',
          season_id: season.id)
        Movie.create(name:'Why Him?',
          plot:'A dad forms a bitter rivalry with his daughter\'s young rich boyfriend.',
          actors:'James Franco, Bryan Cranston, Zoey Deutch',
          release_date:'2016-12-25T05:00:00Z',
          director:'John Hamburg',
          imdb: 'http://www.imdb.com/title/tt4501244',
          rotten_tomatoes_id:'771430512',
          season_id: season.id)
      end
      dir.down do
        season = Season.where(name:'Winter 2016').first
        Movie.where(season_id: season.id).destroy_all
      end
    end
  end
end
