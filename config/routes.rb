Rails.application.routes.draw do
  get 'welcome/index'

  devise_for :users
  resources :dictionaries, except: [:new, :create, :delete, :destroy] do
    resources :words do
      member do
        get :subtypes
      end
    end
  end

  resources :resources
  root 'welcome#index'
end
