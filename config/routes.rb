PeaceCorpsAfrica::Application.routes.draw do

  resources :initiatives

  resources :countries

  authenticated :user do
    root :to => 'home#index'
  end
  
  root :to => "home#index"
  
  devise_for :users
  
  resources :users, :only => [:show, :index]

  namespace :initiative, :path => '/:abbreviation', :constraints => { :abbreviation => /[a-z]{3,7}/i } do
    get '/' => 'home#index', :as => :home
  end

  namespace :country, :path => '/:country_code', :constraints => { :country_code => /[a-z]{2}/i } do
    resources :initiatives
    get '/' => 'home#index', :as => :home
  end

end
