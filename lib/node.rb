class Node < Element

  def distance_to node
    GeoDistance::Haversine.distance( @data['lat'], @data['lon'], node['lat'], node['lon'] ).meters.number
  end

end