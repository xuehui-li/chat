class LinkSerializer < ActiveModel::Serializer
  self.root = false
  attributes :url, :title

  def attributes
    hash = super
    hash.each do |key, value|
      hash.delete(key) if value.nil?
    end
    hash
  end
end
