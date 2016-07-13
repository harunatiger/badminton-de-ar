# encoding: utf-8

class DefaultImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  process :auto_orient

  # Process files as they are uploaded:
  # process scale: [1200, 900]
  process resize_to_fit: [1440, 1080]
  #
  # def scale(width, height)
  #   # do something
  # end
  

  # Create different versions of your uploaded files:
  version :thumb do
    process :auto_orient
    process :crop
    process resize_to_fit: [560, 420]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    if model.respond_to?(:image_blank_ok) and model.image_blank_ok
      ['jpg', 'jpeg', 'gif', 'png', '']
    else
      %w(jpg jpeg gif png)
    end
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
  
  private

    def crop
      return unless defined? model.image_crop_x # profile_image only
      return unless [model.image_crop_x, model.image_crop_y, model.image_crop_w, model.image_crop_h, model.image_resize_w, model.image_resize_h].all?
      manipulate! do |img|
        img.resize!(model.image_resize_w, model.image_resize_h)
        crop_x = model.image_crop_x.to_i
        crop_y = model.image_crop_y.to_i
        crop_w = model.image_crop_w.to_i
        crop_h = model.image_crop_h.to_i
        img.crop!(crop_x,crop_y,crop_w,crop_h)
        #img.crop "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
        img = yield(img) if block_given?
        img
      end
    end
end
