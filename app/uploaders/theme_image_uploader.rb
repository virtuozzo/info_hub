class ThemeImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "themes/#{model.secure_id}"
  end

  def filename
    if original_filename
      @uniq_filename ||= "#{mounted_as}-#{model.class.uniq_token_for(mounted_as)}.#{model.send(mounted_as).file.extension}"
    end
  end
end