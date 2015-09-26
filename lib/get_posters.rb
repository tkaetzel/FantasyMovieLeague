require 'net/http'
require 'open-uri'
require 'json'

uri = URI('https://imdb.p.mashape.com/movie')
movies = ['tt2379713','tt2452042','tt2006295','tt3707106','tt1951266','tt3569230','tt3076658',
'tt1979388','tt3530002','tt1976009','tt3850590','tt1390411','tt1596363','tt2488496','tt1850457',
'tt3322364','tt1528854','tt2446980','tt2058673','tt3460252']

movies.each do |m|

  Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
    request = Net::HTTP::Post.new uri
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['Accept'] = 'application/json'
    request['X-Mashape-Key'] = 'CaK9rRX4xHmshmaCf8d8oTyOjOTDp1rstoWjsnDN5hwKdAR5zE'
    request.set_form_data('searchTerm' => m)
    
    response = http.request(request)
    
    jsonStr = response.body
    json = JSON.parse(jsonStr)
    posterUri = json['result']['poster']
    
    download = open(posterUri)
    IO.copy_stream(download, format('../app/assets/images/posters/%s.jpg', m))
  end
  sleep 1
end