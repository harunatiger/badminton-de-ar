# encoding: utf-8

class MessageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :save_content_type_and_set_filename
  process :auto_orient

  def store_dir
    "uploads/message/#{mounted_as}/#{model.id}"
  end

  version :preview do
    process :cover
    process :convert => 'png'
    process resize_to_limit: [940, 500]
  end

  def cover
    manipulate! do |frame, index|
      frame if index.zero?
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png pdf)
  end

  def save_content_type_and_set_filename
    model.attached_extension = file.content_type if file.content_type
    model.attached_name = original_filename if original_filename
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
    #'something.jpg' if original_filename
  #end
  def filename
    "#{secure_token}" if original_filename.present?
  end
  
  def auto_orient
    manipulate! do |img|
      img = img.auto_orient
    end
  end
  
  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end