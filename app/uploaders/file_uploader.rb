# encoding: utf-8
require 'carrierwave/processing/rmagick'

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "system/tmp_uploads"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  #def default_url
  #  ActionController::Base.helpers.asset_path("users/" + [version_name, "default.jpg"].compact.join('_'))
  #end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [80, 80]
  end
  
  version :wide do
    process :resize_to_fit => [150, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
