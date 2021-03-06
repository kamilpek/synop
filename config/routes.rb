Rails.application.routes.draw do

  resources :alerts
  resources :categories
  resources :clients
  resources :gw_measurs
  resources :gw_stations
  get 'admin/main'
  get 'admin/users'
  get 'pages/home'
  get 'pages/forecast'
  get 'pages/metar'
  get 'pages/gios'
  get 'pages/radars'
  get 'pages/radars_gda'
  get 'pages/visir'
  get 'pages/bonn_gfs'
  get 'pages/bonn_cosmo'
  get 'pages/safir'
  get 'pages/osm'
  get 'pages/stats'
  get 'pages/nowcasting'
  get 'pages/monitor'
  get 'pages/radio'
  get 'pages/dwd'
  get 'pages/eumetsat'
  get 'pages/forecast_map'
  get 'pages/showers'
  get 'pages/um'
  get 'pages/aladin'
  get 'pages/about'
  get 'pages/measurements'
  get 'pages/gw'
  get 'pages/cosmo'
  get 'pages/rtr'
  get 'pages/rainviewer'
  get 'pages/alerts'
  get 'pages/petrobaltic'
  get 'pages/lightings'
  get 'pages/satbaltyk'
  get 'pages/wetter'
  get 'pages/estofex_gfs'
  get 'pages/jsmsg'

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

  scope "alerts" do
    resources :alerts do
      get 'activate'
      get 'deactivate'
    end
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
      resources :alerts do
        collection do
          get 'alerts'
          get 'all'
        end        
      end
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
