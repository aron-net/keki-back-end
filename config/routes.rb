# Rails.application.routes.draw do
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Defines the root path route ("/")
#   # root "articles#index"
# end
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'session#signup'
      post 'signin', to: 'session#signin'
      delete 'signout', to: 'session#signout'
    end
  end
end

