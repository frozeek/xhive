module Xhive
  class Mailer
    attr :site, :resource, :action, :key, :mailer, :content, :page

    def initialize(site, mailer, key = nil)
      @site = site
      @resource = mailer.class.name.underscore
      @mailer = mailer
      @action = mailer.action_name
      @key = key
      @page = Xhive::Mapper.page_for(@site, @resource, @action, @key)
    end

    # Public: sends the email to the specified recipients.
    #
    # opts  - The Hash containing the email sending options.
    #
    #         :from
    #         :to
    #         :reply_to
    #         :subject (uses page title if mapper is found)
    #
    # block - The block for customizing the email sending.
    #
    def send(opts = {}, &block)
      unless block_given?
        mailer.send(:mail, opts.merge(:subject => subject || opts[:subject])) do |format|
          format.html { mailer.render :text => content }
        end
      else
        yield content
      end
    end

    # Public: returns the email content body.
    #
    # Returns: the rendered template or the mapped page content body.
    #
    def content
      return @content if @content.present?
      @content = page.present? ? page.present_content(mailer_instance_variables(mailer)) : mailer.render
    end

    # Public: returns the email subject.
    #
    # Returns: the rendered template or the mapped page content body.
    #
    def subject
      @subject = page.present? ? page.present_title(mailer_instance_variables(mailer)) : nil
    end

  private

    # Private: extracts the instance variables from the mailer object.
    #
    # mailer - The ActionMailer::Base object.
    #
    # Returns: a Hash with all the instance variables instantiated.
    #
    def mailer_instance_variables(mailer)
      internal_vars = [:@_routes, :@_action_has_layout, :@_message, :@_prefixes, :@_lookup_context, :@_action_name, :@_response_body]
      vars = mailer.instance_variables - internal_vars
      opts = {}
      vars.each {|v| opts[v.slice(1..-1).to_sym] = mailer.instance_variable_get(v)}
      opts
    end
  end
end
