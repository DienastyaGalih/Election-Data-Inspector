Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  get '/', to: 'home#index'
  namespace :admin do
    # sidekiq monitoring UI
    mount Sidekiq::Web => '/monitoring/sidekiq'
    get 'reports/summary', to: 'reports#summary'
    get 'reports/api_total_votes', to: 'reports#api_total_votes'
    resources :candidates, except: %i[new edit destroy]
    resources :candidate_results
    resources :result_trackers, except: %i[new edit]
    resources :provinsis, except: %i[new edit] do 
      collection do
        get :api_list
      end
    end
    resources :kabupaten_kotas, except: %i[new edit] do
      collection do
        get :api_list
      end
    end
    resources :kecamatans, except: %i[new edit] do
      collection do
        get :api_list
      end
    end
    resources :desa_kelurahans, except: %i[new edit] do
      collection do
        get :api_list
      end
    end
    resources :results
    resources :result_sources, except: %i[new edit] do
      collection do
        get :api_list
      end
    end
    resources :pooling_stations, except: %i[new edit] do
      collection do
        get :api_list
      end
    end
    resources :users
    resources :verificators

    root to: 'candidates#index'
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
