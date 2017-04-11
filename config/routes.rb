Rails.application.routes.draw do
  resources :project_prototypes, only: :show

  resources :activities
  get 'structure_elements/new'

  get 'shippings/index'

  get 'shippings/new'

  get 'shippings/edit'

  get 'welcome/index'

  devise_for :users
  resources :dictionaries, except: [:new, :create, :delete, :destroy] do
    resources :words do
      member do
        get :subtypes
      end
    end
  end
  resources :daily_currencies
  resources :shippings
  resources :resources
  resources :projects
  root 'welcome#index'
end
