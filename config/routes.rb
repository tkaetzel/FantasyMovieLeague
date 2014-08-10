Ruby::Application.routes.draw do
  get "/revenues", to: "revenues#index"
  get "/shares", to: "application#shares"
  get "/shares/:team", to: "application#shares"
  get "/graph/details", to: "graph#details"
  get "/graph/details/:movie", to: "graph#details"
  get "/graph/:type", to: "graph#get_graph"
  get "/graph/:type/:team", to: "graph#get_graph"
  get "/new", to: "new#index"
  get "/api/:action", controller: "api"
  get "/api/:action/:team", controller: "api"
  get "/:team", to: "application#index"

  post "/new/create", to: "new#create"
  
  root 'application#index'

end
