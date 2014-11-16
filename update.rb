require 'rubygems'
require 'bundler'

Bundler.require :default

Dir["./lib/*.rb"].each {|file| require file }

networks = ['Городской транспорт Перми']

networks.each do |network_name|

  network = Network.new(network_name)

  if network

    out = ['# ' + network_name]

    ['bus', 'trolleybus', 'tram'].each do |transport|
      out << "## #{transport}"
      out << %w(route type platforms stops length link).join(' | ')
      out << (["---"] * 7).join(' | ')
      out << network.relations.
      select{ |el|
        el['tags'] && el['tags']['type'] &&
        ['route', 'route_master'].include?(el['tags']['type']) &&
        el['tags'][el['tags']['type']] == transport
      }.
      sort_by{|el|
        [ # order
          el['tags']['name'].split(' ')[0],
          el['tags']['ref'].to_i,
          ['route_master', 'route'].find_index(el['tags']['type'])
        ] }.
      map{ |el|
        [ # row
          el['tags']['name'],
          el['tags']['type'] == 'route_master' ? 'master' : '',
          # el['tags']['operator'],
          el['members'].select{|e| e['role'] == 'platform' }.size,
          el['members'].select{|e| e['role'] == 'stop' }.size,
          # el.ways.size,
          ("%.1f km" % (el.ways.map(&:length).inject(&:+) / 1000) rescue ' '),
          "[#{el['id']}](http://openstreetmap.org/relation/#{el['id']})"].join(' | ')
      }
      out << ""
    end

    out = out.flatten.join("\n")

    File.open("#{network_name}.md", 'w') do |file|  
      file.puts out
    end

    puts out
 
  end

end