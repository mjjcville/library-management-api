Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'
  namespace :api do
    namespace :v1 do
      resources :libraries, only: [:create]
      resources :borrowers, only: [:create] do
        member do
          get  :fee_total
          post :pay
        end
      end
      resources :books, only: [:index, :create] 
      resources :book_copies, only: [] do 
        member do
          post :checkout
          patch :checkin
        end
      end
    end
  end
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
end
