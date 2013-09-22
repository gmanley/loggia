class RandomRecordQuery

  def initialize(relation)
    @relation = relation
  end

  def perform
    @relation.offset(rand(@relation.count)).first
  end
end
