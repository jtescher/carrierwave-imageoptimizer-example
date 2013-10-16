# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  storage :file
  process :optimize

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :fixed_large do
    process :crop
    process resize_to_fill: [570, 380]
  end


  def crop
    if model.respond_to?(:crop_x) && model.crop_x.present?
      resize_to_limit(600, 600)
      manipulate! do |img|
        img.crop("#{200}x#{200}+#{0}+#{0}")
        img
      end
    end
  end
end
