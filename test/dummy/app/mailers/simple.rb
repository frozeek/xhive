class Simple < ActionMailer::Base
  default from: "from@example.com"

  def test
    mailer = Xhive::Mailer.new(Xhive::Site.first, self, 'test-key')
    mailer.send :to => 'recipient@hishouse.com', :subject => 'Test email'
  end
end
