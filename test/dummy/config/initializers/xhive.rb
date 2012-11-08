require 'xhive'

Xhive::Router::Cells.draw do |router|
  router.mount 'weather/:city', :to => 'weather#show'
  router.mount 'stylesheet/:id', :to => 'xhive/stylesheet#inline', :inline => true
end

