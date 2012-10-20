class DocumentObserver < ActiveRecord::Observer
  observe :document

  def before_validation(model)
    if model.file.present? && model.file_changed?
      model.file_content_type = model.file.file.content_type unless model.file.file.content_type.blank? || !model.attributes.has_key?('file_content_type')
      model.file_file_size = model.file.file.size if model.attributes.has_key? 'file_file_size'
      model.file_hash = Digest::MD5.hexdigest(model.file.read) if model.attributes.has_key? 'file_hash'
    end

    if model.source.present? && model.source_changed?
      model.source_content_type = model.source.file.content_type unless model.source.file.content_type.blank? || !model.attributes.has_key?('source_content_type')
      model.source_file_size = model.source.file.size if model.attributes.has_key? 'source_file_size'
      model.source_hash = Digest::MD5.hexdigest(model.source.read) if model.attributes.has_key? 'source_hash'
    end
  end
end
