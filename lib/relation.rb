class Relation < Element

  def members
    @members ||= @data['members'].map do |member|
      @network.element_by_id(member['ref'])
    end
  end

  def member_by_id id
    members.select{|el| el.id == id}.first
  end

  def ways
    members.select{|el| el.is_a?(Way) }
  end

  def nodes
    members.select{|el| el.is_a?(Node) }
  end

  def relations
    members.select{|el| el.is_a?(Relation) }
  end
end