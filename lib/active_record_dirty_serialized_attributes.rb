module ActiveRecordDirtySerializedAttributes
  def after_initialize
    if self.class.serialized_attributes.any?
      clean_serialized_attributes = self.class.serialized_attributes.keys.inject({}) do |hash,key|
	hash[key] = send(key)
	hash
      end
      @original_serialized_attributes = clean_serialized_attributes
    end
  end

  def changed_attributes
    @changed_attributes ||= {}
    @original_serialized_attributes.each do |k,v|
      if !@changed_attributes.has_key?(k) && (send(k) != v)
	@changed_attributes[k] = v
      end
    end
    @changed_attributes
  end

  def update
    raise 'dumb'
    if partial_updates?
      update_without_dirty(changed)
    else
      update_without_dirty
    end
  end
end
