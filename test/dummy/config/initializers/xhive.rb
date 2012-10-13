require 'xhive'

Xhive::Routes.draw do |router|
  router.mount 'weather/:city', :to => 'weather#show'
end

