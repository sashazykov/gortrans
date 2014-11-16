class Element
  attr_accessor :data
  attr_accessor :network

  def initialize network, data
    @data = data
    @network = network
  end

  def [] key
    @data[key]
  end

  def id
    @data['id']
  end

  def inspect
    "<#{self.class} #{@data}>"
  end

end