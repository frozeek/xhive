require 'friendly_id'
require 'sass'

module Xhive
  class Stylesheet < ActiveRecord::Base
    extend ::FriendlyId
    friendly_id :name, use: :slugged

    include Xhive::Presentable

    attr_accessible :content, :name, :slug, :site_id

    belongs_to :site

    validates :name, :presence => true, :uniqueness => { :scope => :site_id }
    validates :content, :presence => true
    validates :site, :presence => true
    validate  :css_syntax, :if => Proc.new { self.content.present? }

  private

    def css_syntax
      engine = Sass::Engine.new(content, :syntax => :scss)
      engine.render
    rescue Sass::SyntaxError => e
      errors.add(:content, e.message)
    end
  end
end
