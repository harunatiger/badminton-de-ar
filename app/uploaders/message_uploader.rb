# encoding: utf-8
# require 'carrierwave/processing/mime_types'

class MessageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  #include CarrierWave::MimeTypes

  process :save_content_type_and_set_filename

  # include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/message/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [1200, 900]
   #
  # def scale(width, height)
  #   # do something
  # end

  #process :filename

  # Create different versions of your uploaded files:
  version :thumb do
    process :cover
    process :convert => 'jpg'
    process resize_to_fit: [200, 150]
  end

  def cover
    manipulate! do |frame, index|
      frame if index.zero?
    end
  end

  version :preview do
    process :cover
    process :convert => 'jpg'
    process resize_to_fit: [600, 500]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png pdf)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
  #'something.jpg' if original_filename
  #end

  def filename
    "#{secure_token}" if original_filename.present?
  end

  def save_content_type_and_set_filename
    model.attached_extension = file.content_type if file.content_type
    model.attached_name = original_filename if original_filename
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end