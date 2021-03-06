Foodsoft::Application.routes.draw do

  get "order_comments/new"

  get "comments/new"

  get "sessions/new"

  root to: 'sessions#redirect_to_foodcoop', as: nil

  scope '/:foodcoop' do

    # Root path
    root to: 'home#index'

    ########### Sessions

    get   '/login' => 'sessions#new', as: 'login'
    get   '/logout' => 'sessions#destroy', as: 'logout'
    get   '/login/forgot_password' => 'login#forgot_password', as: :forgot_password
    post  '/login/reset_password' => 'login#reset_password', as: :reset_password
    get   '/login/new_password' => 'login#new_password', as: :new_password
    patch '/login/update_password' => 'login#update_password', as: :update_password
    match '/login/accept_invitation/:token' => 'login#accept_invitation', as: :accept_invitation, via: [:get, :post]
    resources :sessions, only: [:new, :create, :destroy]

    get '/foodcoop.css' => 'styles#foodcoop', as: 'foodcoop_css'

    ########### User specific

    get   '/home/profile', as: 'my_profile'
    patch '/home/update_profile', as: 'update_profile'
    get   '/home/ordergroup' => 'home#ordergroup', as: 'my_ordergroup'
    post  '/home/cancel_membership' => 'home#cancel_membership', as: 'cancel_membership'

    ############ Orders, ordering

    resources :orders do
      member do
        post :finish
        post :add_comment
        post :send_result_to_supplier

        get :receive
        post :receive

        get :receive_on_order_article_create
        get :receive_on_order_article_update
      end

      resources :order_articles
    end

    resources :pickups, only: [:index] do
      post :document, on: :collection
    end

    resources :group_orders do
      get :archive, on: :collection
    end

    resources :group_order_articles

    resources :order_comments, only: [:new, :create]

    ############ Foodcoop orga

    resources :invites, only: [:new, :create]

    resources :tasks do
      collection do
        get :user
        get :archive
        get :workgroup
      end
      member do
        post :accept
        post :reject
        post :set_done
      end
    end

    namespace :foodcoop do
      root to: 'users#index'

      resources :users, only: [:index]

      resources :ordergroups, only: [:index]

      resources :workgroups, only: [:index, :edit, :update]
    end

    ########### Article management

    resources :stock_takings do
      collection do
        get :fill_new_stock_article_form
        post :add_stock_article
      end
    end

    resources :stock_articles, controller: 'stockit' do
      get :copy
      collection do
        get :derive

        get :index_on_stock_article_create
        get :index_on_stock_article_update

        get :show_on_stock_article_update
      end
    end

    resources :suppliers do
      get :shared_suppliers, on: :collection

      resources :deliveries do
        collection do
          post :add_stock_change

          get :form_on_stock_article_create
          get :form_on_stock_article_update
        end
      end

      resources :articles do
        collection do
          post :update_selected
          get :edit_all
          post :update_all
          get :upload
          post :parse_upload
          post :create_from_upload
          get :shared
          get :import
          post :sync
          post :update_synchronized
        end
      end
    end

    resources :article_categories

    ########### Finance

    namespace :finance do
      root to: 'base#index'

      resources :order, controller: 'balancing', path: 'balancing' do
        member do
          get :update_summary
          get :edit_note
          put :update_note

          get :confirm
          post :close
          patch :close_direct

          get :new_on_order_article_create
          get :new_on_order_article_update
        end
      end

      resources :invoices do
        get :attachment
        get :form_on_supplier_id_change, on: :collection
        get :unpaid, on: :collection
      end

      resources :links, controller: 'financial_links', only: [:show]

      resources :ordergroups, only: [:index] do
        resources :financial_transactions, as: :transactions
      end
      get 'transactions' => 'financial_transactions#index_collection'

      get 'transactions/new_collection' => 'financial_transactions#new_collection', as: 'new_transaction_collection'
      post 'transactions/create_collection' => 'financial_transactions#create_collection', as: 'create_transaction_collection'
    end

    ########### Administration

    namespace :admin do
      root to: 'base#index'

      resources :finances, only: [:index] do
        get :update_transaction_types, on: :collection
      end

      resources :financial_transaction_classes
      resources :financial_transaction_types

      resources :users do
        post :restore, on: :member
        post :sudo, on: :member
      end

      resources :workgroups do
        get :memberships, on: :member
      end

      resources :ordergroups do
        get :memberships, on: :member
      end

      resources :mail_delivery_status, only: [:index, :show, :destroy] do
        delete :index, on: :collection, action: :destroy_all
      end

      resource :config, only: [:show, :update] do
        get :list
      end
    end

    ############## Feedback

    resource :feedback, only: [:new, :create], controller: 'feedback'

    ############## The rest

    resources :users, only: [:index]

  end # End of /:foodcoop scope
end
