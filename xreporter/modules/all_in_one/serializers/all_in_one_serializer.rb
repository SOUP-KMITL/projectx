class AllInOneSerializer < ActiveModel::Serializer
  self.root = false
  attributes :overall_score, :overall_description
  has_many :nodes, serializer: AttackNodeSerializer

  def overall_score
    object.overall_score.round(2)
  end
end
