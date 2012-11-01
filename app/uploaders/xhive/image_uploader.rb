require 'carrierwave'

module Xhive
  class ImageUploader < ::CarrierWave::Uploader::Base
    include ::CarrierWave::MiniMagick

    include ::Sprockets::Helpers::RailsHelper
    include ::Sprockets::Helpers::IsolatedHelper

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    def default_url
      asset_path "fallback/" + [version_name, "default.png"].compact.join('_')
    end

    def url
      super.gsub('+', '%2B')
    end

    version :thumb do
      process :resize_to_limit => [144, 94]
    end

    def extension_white_list
      %w(jpg jpeg gif png)
    end

    # For heroku read-only filesystem
    def cache_dir
      "#{Rails.root}/tmp/uploads"
    end
  end
end
