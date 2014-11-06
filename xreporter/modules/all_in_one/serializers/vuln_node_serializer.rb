class VulnNodeSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :xmodule, :severity
end

