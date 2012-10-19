require 'xhive'

Xhive::Router::Cells.draw do |router|
  router.mount 'weather/:city', :to => 'weather#show'
end

