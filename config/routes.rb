Xhive::Engine.routes.draw do
  resources :pages, :only => :show do
    get 'widget', :on => :member
  end

  get 'stylesheets/custom.css', :to => 'stylesheets#index', :as => :stylesheets, :format => :css

  resources :stylesheets, :only => :show, :format => :css
  resources :images, :only => :show

  get 'widgets/*widget', :to => 'widgets#show'

  root :to => 'pages#show'
end
