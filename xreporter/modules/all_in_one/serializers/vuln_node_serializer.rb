class VulnNodeSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :xmodule, :description, :severity, :cve_url

  def name
    object.name if object.respond_to?(:name)
  end

  def xmodule
    object.xmodule if object.respond_to?(:xmodule)
  end

  def description
    object.description if object.respond_to?(:description)
  end

  def cve_url
    if object.respond_to?(:cve_url)
      object.cve_url unless object.cve_url.empty?
    end
  end
end

