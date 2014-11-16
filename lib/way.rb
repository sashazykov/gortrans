class Way < Element
  def nodes
    @nodes ||= @data['nodes'].map do |node|
      @network.element_by_id(node)
    end
  end

  def length
    (0..(nodes.length - 2)).to_a.map do |index|
      nodes[index].distance_to(nodes[index+1])
    end.inject(:+)
  end
end