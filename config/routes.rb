Rails.application.routes.draw do
  resources :forecasts
  get 'admin/main'

  get 'admin/users'

  get 'pages/home'
  get 'pages/forecast'
  get 'pages/stats'
  get 'pages/about'

  resources :measurements
  resources :stations
  devise_for :users

  resources :measurements do
    collection { post :import }
    get :direct_import
    get 'daily'
    get 'hourly'
    get 'hourly_map'
  end

  scope "forecasts" do
    resources :forecasts do
      member do
        get 'daily'
        get 'hourly'
        get 'hourly_map'
      end
    end
  end

  resources :stations do
    collection { post :import }
  end

  scope "admin" do
    resources :users do
      member do
        delete 'destroy'
        get 'new'
        post 'create'
        get 'edit'
        patch 'update'
        get 'notes'
        post 'grantadmin'
        post 'resetpassword'
      end
    end
  end

  scope "stations" do
    resources :stations do
      member do
        get 'measur'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :measurements do
        get 'measurements' => 'measurements#index'
      end
      resources :forecasts do
        get 'forecasts' => 'forecasts#index'
      end
    end
  end

  root 'pages#home'

end
