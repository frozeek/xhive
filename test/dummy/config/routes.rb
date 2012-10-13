Rails.application.routes.draw do
  mount Xhive::Engine => "/"

  resources :posts, :only => :show
end
