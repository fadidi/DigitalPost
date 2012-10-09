class PhotoObserver < ActiveRecord::Observer
  observe :unit, :photo

  def before_validation(model)
    if model.photo.present? && model.photo_changed?
      model.photo_content_type = model.photo.file.content_type unless model.photo.file.content_type.blank?
      model.photo_file_size = model.photo.file.size
      model.photo_hash = Digest::MD5.hexdigest(model.photo.read) if model.attributes.has_key? 'photo_hash'
      model.photo_width = MiniMagick::Image.open(model.photo.file.path)['width'] if model.attributes.has_key? 'photo_width'
      model.photo_height = MiniMagick::Image.open(model.photo.file.path)['height'] if model.attributes.has_key? 'photo_height'
    end
  end
end
