Rails.application.routes.draw do
  get 'admin/main'

  get 'admin/users'

  get 'pages/home'
  get 'pages/stats'
  get 'pages/about'

  resources :measurements
  resources :stations
  devise_for :users

  resources :measurements do
    collection { post :import }
    get :direct_import
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

  root 'pages#home'

end
