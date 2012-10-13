Xhive::Engine.routes.draw do
  resources :pages, :only => :show do
    get 'widget', :on => :member
  end

  get 'widgets/*widget', :to => 'widgets#show'

  root :to => 'pages#show'
end
