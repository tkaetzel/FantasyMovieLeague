Ruby::Application.routes.draw do
  get "/revenues", to: "revenues#index"
  get "/shares/(:team)", to: "main#shares"
  get "/graph/:action/(:id)", controller: "graph"
  get "/new", to: "new#index"
  get "/api/:action/(:id)", controller: "api"
  get "/feed", to: "feed#index"
  get "/:team", to: "main#index"

  post "/new/create", to: "new#create"
  
  root 'main#index'

end
