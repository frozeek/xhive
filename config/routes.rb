Xhive::Engine.routes.draw do
  resources :pages, :only => :show do
    get 'widget', :on => :member
  end

  root :to => 'pages#show'
end
