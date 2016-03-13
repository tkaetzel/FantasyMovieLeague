require 'net/http'
require 'open-uri'
require 'json'

uri = URI('https://imdb.p.mashape.com/movie')
movies = ['tt3498820','tt1458169','tt2241351','tt1985949','tt4438848','tt3799694','tt2567026','tt3385516','tt3960412','tt3949660','tt3065204','tt3110958','tt0803096','tt1489889','tt2277860','tt1124037','tt1628841','tt3691740','tt0918940','tt4094724','tt2823054','tt2709768','tt1289401','tt3416828','tt2660888','tt4196776','tt3922818','tt4276820','tt1386697','tt2788732']

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