require 'test_helper'

module Xhive
  class MailMock
    def initialize
      @user = "the user"
      @product = "the product"
    end

    def render(opts={})
      opts[:text] || 'file template'
    end

    def action_name
      'my_action'
    end

    def mail(opts={}, &block)
      body = yield Formatter.new
      Hashy.new(:to => opts[:to],
                :from => opts[:from],
                :reply_to => opts[:reply_to],
                :subject => opts[:subject],
                :body => body)
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
      @vars = { :user => "the user", :product => "the product" }
      @page = Hashy.new(:present_content => 'dynamic content', :present_title => 'dynamic subject')
      @action_mailer = MailMock.new
    end

    context 'content' do
      should 'render email content if no page is mapped' do
        Xhive::Mapper.expects(:page_for).with(@site, 'xhive/mail_mock', @action, @key, @vars).returns(nil)

        @mailer = Xhive::Mailer.new(@site, @action_mailer, @key)

        assert_equal 'file template', @mailer.content
      end

      should 'render page content if has mapped page' do
        Xhive::Mapper.expects(:page_for).with(@site, 'xhive/mail_mock', @action, @key, @vars).returns(@page)

        @mailer = Xhive::Mailer.new(@site, @action_mailer, @key)

        assert_equal 'dynamic content', @mailer.content
      end
    end

    context 'send' do
      setup do
        Xhive::Mapper.expects(:page_for).with(@site, 'xhive/mail_mock', @action, @key, @vars).returns(@page)
        @mailer = Xhive::Mailer.new(@site, @action_mailer, @key)
      end

      should 'yield the block with the mail content' do
        @mailer.stubs(:content).returns('mail content')
        result = @mailer.send do |content|
          "Email: #{content}"
        end

        assert_equal "Email: mail content", result
      end

      should 'trigger the email with the mail content' do
        result = @mailer.send(:to => 'john@doe.com')

        assert_equal '<html>dynamic content</html>', result.body
        assert_equal 'dynamic subject', result.subject
      end
    end
  end
end
