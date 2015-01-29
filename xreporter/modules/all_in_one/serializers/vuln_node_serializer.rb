class VulnNodeSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :xmodule, :description, :severity

  def name
    object.name if object.respond_to?(:name)
  end

  def xmodule
    object.xmodule if object.respond_to?(:xmodule)
  end

  def description
    object.description if object.respond_to?(:description)
  end
end

