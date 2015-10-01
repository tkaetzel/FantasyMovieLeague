class AddMoviesForWinter2015 < ActiveRecord::Migration
  def change
    change_table :movies do |t|
      t.column(:limited, :boolean, :null => false, :default => false)
    end
    
    reversible do |dir|
      dir.up do
        season = Season.where(name:'Winter 2015').first
        
        Movie.create(name:'Spectre',
         plot:"A cryptic message from James Bond's past sends him on a trail to uncover a sinister organization.",
         actors:"Daniel Craig, Cristoph Waltz",
         release_date:'2015-11-06',
         director:'Sam Mendes',
         imdb:'http://www.imdb.com/title/tt2379713',
         rotten_tomatoes_id:'771360513',
         season_id: season.id)
        Movie.create(name:'The Peanuts Movie',
         plot:"Snoopy embarks upon his greatest mission as he and his team take to the skies to pursue their arch-nemesis, while his best pal Charlie Brown begins his own epic quest back home.",
         actors:"Noah Schnapp, Bill Melendez",
         release_date:'2015-11-06',
         director:'Steve Martino',
         imdb:'http://www.imdb.com/title/tt2452042',
         rotten_tomatoes_id:'771318152',
         season_id: season.id)
        Movie.create(name:'The 33',
         plot:"The true story of 33 Chilean miners who were trapped in the San Jose Mine for 69 days in 2010.",
         actors:"Antonio Banderas, Jennifer Lopez, Martin Sheen",
         release_date:'2015-11-13',
         director:'Patricia Riggen',
         imdb:'http://www.imdb.com/title/tt2006295',
         rotten_tomatoes_id:'771359098',
         season_id: season.id)
        Movie.create(name:'By The Sea',
         plot:"A married couple takes a vacation in France in the 1970s and find that their time in a sleepy seaside town, complete with a unique array of locals, strengthens their bond and reaffirms their marriage.",
         actors:"Brad Pitt, Angelina Jolie",
         release_date:'2015-11-13',
         director:'Angelina Jolie',
         imdb:'http://www.imdb.com/title/tt3707106',
         rotten_tomatoes_id:'771419173',
         season_id: season.id)
        Movie.create(name:'The Hunger Games: Mockingjay - Part 2',
         plot:"After being symbolized as the \"Mockingjay\",
         Katniss Everdeen and District 13 engage in an all-out revolution against the autocratic Capitol.",
         actors:"Jennifer Lawrence, Josh Hutcherson, Liam Hemsworth",
         release_date:'2015-11-20',
         director:'Francis Lawrence',
         imdb:'http://www.imdb.com/title/tt1951266',
         rotten_tomatoes_id:'771312089',
         season_id: season.id)
        Movie.create(name:'Creed',
         plot:"The former World Heavyweight Champion Rocky Balboa serves as a trainer and mentor to Adonis Creed, the son of his late friend and former rival Apollo Creed.",
         actors:"Sylvester Stallone, Michael B. Jordan",
         release_date:'2015-11-25',
         director:'Ryan Coogler',
         imdb:'http://www.imdb.com/title/tt3076658',
         rotten_tomatoes_id:'771413507',
         season_id: season.id)
        Movie.create(name:'The Good Dinosaur',
         plot:"While traveling through a harsh and mysterious landscape, Arlo the Apatosaurus learns the power of confronting his fears and discovers what he is truly capable of.",
         actors:"Raymond Ochoa, Jeffrey Wright",
         release_date:'2015-11-25',
         director:'Peter Sohn',
         imdb:'http://www.imdb.com/title/tt1979388',
         rotten_tomatoes_id:'771306093',
         season_id: season.id)
        Movie.create(name:'The Night Before',
         plot:"In New York City for their annual tradition of Christmas Eve debauchery, three lifelong best friends set out to find the Holy Grail of Christmas parties since their yearly reunion might be coming to an end.",
         actors:"Joseph Gordon-Levitt, Seth Rogen, Anthony Mackie",
         release_date:'2015-11-25',
         director:'Jonathan Levine',
         imdb:'http://www.imdb.com/title/tt3530002',
         rotten_tomatoes_id:'771379474',
         season_id: season.id)
        Movie.create(name:'Victor Frankenstein',
         plot:"Victor Frankenstein and his assistant Igor Strausman share a noble vision of aiding humanity through their groundbreaking research into immortality, but Victor's experiments go too far, and his obsession has horrifying consequences.",
         actors:"James McAvoy, Daniel Radcliffe",
         release_date:'2015-11-25',
         director:'Paul McGuigan',
         imdb:'http://www.imdb.com/title/tt1976009',
         rotten_tomatoes_id:'771351525',
         season_id: season.id)
        Movie.create(name:'Krampus',
         plot:"A demon seeks out naughty people to punish them at Christmas time.",
         actors:"Adam Scott",
         release_date:'2015-12-04',
         director:'Michael Dougherty',
         imdb:'http://www.imdb.com/title/tt3850590',
         rotten_tomatoes_id:'771387173',
         season_id: season.id)
        Movie.create(name:'In the Heart of the Sea',
         plot:"Based on a true 1820 event, a whaling ship is preyed upon by a sperm whale, stranding its crew at sea for 90 days, thousands of miles from home.",
         actors:"Chris Hemsworth, Cillian Murphy, Brendan Gleeson",
         release_date:'2015-12-11',
         director:'Ron Howard',
         imdb:'http://www.imdb.com/title/tt1390411',
         rotten_tomatoes_id:'771362999',
         season_id: season.id)
        Movie.create(name:'The Big Short',
         plot:"Four outsiders in the world of high-finance who predicted the credit and housing bubble collapse of the mid-2000's decide to take on the big banks for their lack of foresight and greed.",
         actors:"Brad Pitt, Christian Bale, Steve Carell, Ryan Gosling",
         release_date:'2015-12-11',
         director:'Adam McKay',
         imdb:'http://www.imdb.com/title/tt1596363',
         rotten_tomatoes_id:'771377488',
         season_id: season.id,
         limited: true)
        Movie.create(name:'Star Wars: The Force Awakens [60% BUCKET]',
         plot:"The continuation of George Lucas's record-breaking space saga. <strong>This bucket will be valued at 60% of the movie's total gross.</strong>",
         actors:"Harrison Ford, Carrie Fisher, Mark Hamill",
         release_date:'2015-12-18',
         director:'J.J. Abrams',
         imdb:'http://www.imdb.com/title/tt2488496',
         rotten_tomatoes_id:'771321699',
         season_id: season.id)
        Movie.create(name:'Star Wars: The Force Awakens [40% BUCKET]',
         plot:"The continuation of George Lucas's record-breaking space saga. <strong>This bucket will be valued at 40% of the movie's total gross.</strong>",
         actors:"Harrison Ford, Carrie Fisher, Mark Hamill",
         release_date:'2015-12-18',
         director:'J.J. Abrams',
         imdb:'http://www.imdb.com/title/tt2488496',
         rotten_tomatoes_id:'771321699',
         season_id: season.id)
        Movie.create(name:'Sisters',
         plot:"Two sisters decide to throw one last house party before their parents sell their family home.",
         actors:"Amy Poehler, Tina Fey, John Cena",
         release_date:'2015-12-18',
         director:'Jason Moore',
         imdb:'http://www.imdb.com/title/tt1850457',
         rotten_tomatoes_id:'771256395',
         season_id: season.id)
        Movie.create(name:'Concussion',
         plot:"The incredible true David vs. Goliath story of Dr. Bennet Omalu, the brilliant forensic neuropathologist who made the first discovery of CTE, a football-related brain trauma, in a pro player.",
         actors:"Will Smith, Alec Baldwin",
         release_date:'2015-12-25',
         director:'Peter Landesman',
         imdb:'http://www.imdb.com/title/tt3322364',
         rotten_tomatoes_id:'771413218',
         season_id: season.id)
        Movie.create(name:'Daddy\'s Home',
         plot:"An affable radio executive finds himself competing for the affections of his step-children following the unexpected reappearance of his wife's ex-husband.",
         actors:"Will Ferrell, Linda Cardellini, Thomas Haden Church",
         release_date:'2015-12-25',
         director:'Sean Anders, John Morris',
         imdb:'http://www.imdb.com/title/tt1528854',
         rotten_tomatoes_id:'771371542',
         season_id: season.id)
        Movie.create(name:'Joy',
         plot:"The story of a family across four generations and the woman who rises to become founder and matriarch of a powerful family business dynasty.",
         actors:"Jennifer Lawrence, Bradley Cooper",
         release_date:'2015-12-25',
         director:'David O. Russell',
         imdb:'http://www.imdb.com/title/tt2446980',
         rotten_tomatoes_id:'771381879',
         season_id: season.id)
        Movie.create(name:'Point Break',
         plot:"A young FBI agent infiltrates an extraordinary team of extreme sports athletes he suspects of masterminding a string of unprecedented, sophisticated corporate heists. ",
         actors:"Luke Bracey, Teresa Palmer",
         release_date:'2015-12-25',
         director:'Ericson Core',
         imdb:'http://www.imdb.com/title/tt2058673',
         rotten_tomatoes_id:'771254328',
         season_id: season.id)
        Movie.create(name:'The Hateful Eight',
         plot:"In post-Civil War Wyoming, bounty hunters try to find shelter during a blizzard but get involved in a plot of betrayal and deception.",
         actors:"Channing Tatum, Samuel L. Jackson",
         release_date:'2015-12-25',
         director:'Quentin Tarantino',
         imdb:'http://www.imdb.com/title/tt3460252',
         rotten_tomatoes_id:'771372896',
         season_id: season.id,
         limited: true)
      end
      
      dir.down do
        season = Season.where(name:'Winter 2015').first
        Movie.where(season_id: season.id).destroy_all
      end
    end
  end
end
