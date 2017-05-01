class MessageSerializer < ActiveModel::Serializer
  self.root = false
  attributes :mentions, :emoticons, :links

  def attributes
    hash = super
    hash.each do |key, value|
      if value.instance_of?(Array) && value.empty?
        hash.delete(key)
      end
    end
    hash
  end

  def links
    object.links.map do |link|
      ::LinkSerializer.new(link).attributes
    end
  end
end
