require 'uri'
require 'net/http'
require 'json'

class Network

  attr_accessor :elements

  def initialize name
    query = <<-eos
      [out:json];
      (
        relation["network"="#{name}"];
        <;
        >;
      );
      (
        ._;
        rel(br);
      );
      out meta;
      >;
      out body;
    eos

    uri = URI("http://overpass-api.de/api/interpreter")
    uri.query = URI.encode_www_form(data: query)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      @elements = JSON.parse(res.body)['elements'].map do |element|
        Kernel.const_get(element['type'].capitalize).new(self, element)
      end
    else
      return nil
    end
  end

  def element_by_id id
    elements.select{|el| el.id == id}.first
  end

  def ways
    elements.select{|el| el.is_a?(Way) }
  end

  def nodes
    elements.select{|el| el.is_a?(Node) }
  end

  def relations
    elements.select{|el| el.is_a?(Relation) }
  end
end