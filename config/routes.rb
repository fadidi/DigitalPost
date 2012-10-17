DigitalPost::Application.routes.draw do

  resources :case_studies

  resources :links

  resources :photos

  resources :languages

  resources :sectors

  resources :regions

  resources :work_zones

  resources :search, :only => [:index]

  resources :stages

  resources :units

  resources :staff, :only => [:index, :create, :destroy]
  resources :staff, :only => [:show], :controller => 'users'

  resources :volunteers, :only => [:index, :create, :destroy]
  resources :volunteers, :only => [:show], :controller => 'users'

  resources :references

  resources :valid_emails, :except => [:show]

  resources :revisions, :only => [:destroy]

  resources :pages do
    resources :revisions, :except => [:destroy]
  end

  authenticated :user do
    root :to => 'home#index'
  end
  
  #match '/search', :to => 'home#search', :as => :search
  root :to => "home#index"
  
  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
   
  resources :users, :except => [:new, :create]

=begin
  namespace :initiative, :path => '/:abbreviation', :constraints => { :abbreviation => /[a-z]{3,7}/i } do
    resources :countries
    get '/' => 'home#index', :as => :home
  end

  namespace :country, :path => '/:country_code', :constraints => { :country_code => /[a-z]{2}/i } do
    resources :initiatives
    get '/' => 'home#index', :as => :home
  end
=end

end
