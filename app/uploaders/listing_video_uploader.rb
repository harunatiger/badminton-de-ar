# encoding: utf-8

class ListingVideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
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

  # Process files as they are uploaded:
  # process scale: [1200, 900]
  #process resize_to_fit: [1200, 900]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :encoded do
    process :process_encode
  end

  def process_encode
    tmpfile = File.join(File.dirname(current_path), "encoded")
    FileUtils.cp(current_path, tmpfile);pp "#{store_dir}/encoded_#{filename}"
    File.delete(tmpfile)

    #
    if Rails.env.staging? || Rails.env.production?
    #if 1 #for development
      create_elastic_transcoder_job(
        "#{store_dir}/#{filename}",
        "#{store_dir}/encoded_#{filename}"
      )
    end
  end

  def create_elastic_transcoder_job(input_key, output_key)
    Aws.config.update({
      credentials: Aws::Credentials.new(
        ENV["HUBER_AWS_ACCESS_KEY_ID"],
        ENV["HUBER_AWS_SECRET_ACCESS_KEY"]),
      region: ENV["HUBER_AWS_REGION"]})

    pipeline_id = ENV["HUBER_AWS_TRANSCODER_PIPELINE_ID"]
    preset_id = '1351620000001-100240' ##System preset: WEB
    transcoder_client = Aws::ElasticTranscoder::Client.new(region: ENV["HUBER_AWS_REGION"])
    input = { key: input_key }
    output = {
      key: output_key,
      preset_id: preset_id
    }

    transcoder_client.create_job(
      pipeline_id: pipeline_id,
      input: input,
      outputs: [ output ]
    )[:job][:id]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(mp4)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
    #'something.jpg' if original_filename
  #end
  def filename
    "#{secure_token}" if original_filename.present?
  #  "994f0c85-0bbf-482c-bfa6-ed6c9a0c2268" ##for development
  end
  
  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
