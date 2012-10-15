module Xhive
  class AnonymousUser < Xhive::Hashy
    include Xhive::Presentable
    self.presenter_class = 'Xhive::UserPresenter'
  end
end
