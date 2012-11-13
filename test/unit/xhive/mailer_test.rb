require 'test_helper'

module Xhive
  class MailMock
    def render(opts={})
      opts[:text] || 'file template'
    end

    def action_name
      'my_action'
    end

    def mail(opts={}, &block)
      yield Formatter.new
    end

    class Formatter
      def html
        "<html>#{yield}</html>"
      end
    end
  end

  class MailerTest < ActiveSupport::TestCase
    def setup
      @site = Hashy.new(:id => 1)
      @resource = 'my_resource'
      @action = 'my_action'
      @key = 'my_key'
      @page = Hashy.new(:present_content => 'dynamic content')
      @action_mailer = MailMock.new
      @mailer = Xhive::Mailer.new(@site, @action_mailer, @key)
    end

    context 'content' do
      should 'render email content if no page is mapped' do
        Xhive::Mapper.expects(:page_for).with(@site, 'xhive/mail_mock', @action, @key).returns(nil)

        assert_equal 'file template', @mailer.content
      end

      should 'render page content if has mapped page' do
        Xhive::Mapper.expects(:page_for).with(@site, 'xhive/mail_mock', @action, @key).returns(@page)

        assert_equal 'dynamic content', @mailer.content
      end
    end

    context 'send' do
      should 'yield the block with the mail content' do
        @mailer.stubs(:content).returns('mail content')
        result = @mailer.send do |content|
          "Email: #{content}"
        end

        assert_equal "Email: mail content", result
      end

      should 'trigger the email with the mail content' do
        @mailer.stubs(:content).returns('mail content')

        assert_equal '<html>mail content</html>', @mailer.send(:to => 'john@doe.com')
      end
    end
  end
end
