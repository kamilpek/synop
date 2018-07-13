Rails.application.routes.draw do

  get 'admin/main'
  get 'admin/users'
  get 'pages/home'
  get 'pages/forecast'
  get 'pages/metar'
  get 'pages/gios'
  get 'pages/radars'
  get 'pages/safir'
  get 'pages/stats'
  get 'pages/nowcasting'
  get 'pages/monitor'
  get 'pages/icon'
  get 'pages/gfs'
  get 'pages/radio'
  get 'pages/dwd'
  get 'pages/eumetsat'
  get 'pages/forecast_map'
  get 'pages/showers'
  get 'pages/um'
  get 'pages/coamps'
  get 'pages/coamps_ground'
  get 'pages/eport'
  get 'pages/aladin'
  get 'pages/about'

  resources :gios_measurments
  resources :gios_stations
  resources :metar_raports
  resources :metar_stations
  resources :forecasts
  resources :measurements
  resources :stations
  resources :radars
  resources :cities
  devise_for :users

  resources :measurements do
    collection { post :import }
    get :direct_import
    get 'daily'
    get 'hourly'
  end

  scope "forecasts" do
    resources :forecasts do
      member do
        get 'daily'
        get 'hourly'
      end
    end
  end

  resources :gios_measurments do
    get 'daily'
    get 'hourly'
  end

  resources :metar_raports do
    get 'daily'
    get 'hourly'
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

  resources :cities do
    member do
      get 'map'
    end
  end

  resources :radars do
    member do
      get 'daily'
      get 'hourly'
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
      resources :stations do
        get 'stations' => 'stations#index'
      end
      resources :gios_stations do
        get 'gios_stations' => 'gios_stations#index'
      end
      resources :gios_measurements do
        get 'gios_measurements' => 'gios_measurements#index'
      end
      resources :metar_stations do
        get 'metar_stations' => 'metar_stations#index'
      end
      resources :metar_raports do
        get 'metar_raports' => 'metar_raports#index'
      end
    end
  end

  root 'pages#home'

end
