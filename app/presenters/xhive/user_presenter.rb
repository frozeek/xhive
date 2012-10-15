module Xhive
  class UserPresenter < Xhive::BasePresenter
    presents :user
    delegate :email, :first_name, :last_name, :to => :user

    liquid_methods :email, :first_name, :last_name
  end
end
