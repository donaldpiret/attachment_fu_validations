Technoweenie::AttachmentFu::ClassMethods.module_eval do
  ## ORIGINAL
  #def validates_as_attachment
  #  validates_presence_of :size, :content_type, :filename
  #  validate              :attachment_attributes_valid?
  #end
  
  ## EVIL TWIN
  def validates_as_attachment
    validate               :attachment_attributes_valid?
  end
end


Technoweenie::AttachmentFu::InstanceMethods.module_eval do
  ## ORIGINAL 
  #def attachment_attributes_valid?
  #  [:size, :content_type].each do |attr_name|
  #    enum = attachment_options[attr_name]
  #    # Support Rails 2.2 translations, and older default message hash
  #    begin
  #      inclusion_error = I18n.translate('activerecord.errors.messages')[:inclusion]
  #    rescue NameError
  #      inclusion_error = ActiveRecord::Errors.default_error_messages[:inclusion]
  #    end
  #    errors.add attr_name, inclusion_error unless enum.nil? || enum.include?(send(attr_name))
  #  end
  #end
  
  ## EVIL TWIN
  def attachment_attributes_valid?
    if self.filename.nil?
      begin
        nofile_error = I18n.t :'attachment_fu.error_messages.no_file', :default => 'No file uploaded'
      rescue NameError
        nofile_error = "No %{fn} uploaded"
      end
      errors.add_to_base nofile_error
      return
    end
    [:size, :content_type].each do |attr_name|
      enum = attachment_options[attr_name]
      # Support Rails 2.2 translations, and older default message hash
      begin
        inclusion_error = I18n.t(:"attachment_fu.error_messages.no_#{attr_name}", :default => :'activerecord.errors.messages.inclusion', :attribute => attr_name)
      rescue NameError
        inclusion_error = ActiveRecord::Errors.default_error_message[:inclusion]
      end
      errors.add attr_name, inclusion_error unless enum.nil? || enum.include?(send(attr_name))
    end
  end
end
