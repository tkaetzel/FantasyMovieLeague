Ruby::Application.routes.draw do
  get "/revenues", to: "revenues#index"
  get "/shares/(:team)", to: "application#shares"
  #get "/graph/details/(:id)", to: "graph#details"
  get "/graph/:action/(:id)", controller: "graph"
  get "/new", to: "new#index"
  get "/api/:action/(:id)", controller: "api"
  get "/:team", to: "application#index"

  post "/new/create", to: "new#create"
  
  root 'application#index'

end
