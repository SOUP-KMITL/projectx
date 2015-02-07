class XSigma
  class << self
    def from_all_in_one_json(aio_json)
      nodes = []
      edges = []

      x = 0
      y = 1

      aio_json['nodes'].each do |n|
        nodes << {
          id: n['addr'],
          label: n['addr'],
          x: x,
          y: y,
          size: [2,4].sample
        }.merge({ properties: n })

        if x < 4
          if x % 2 == 0
            y -= 1
          else
            y += 1
          end

          x += 1
        else
          x = 0
          y += 3
        end

        n['connections'].each do |conn|
          edges << {
            id: "#{n['addr']}_to_#{conn['node']}",
            source: n['addr'],
            target: conn['node'],
            type: 'arrow',
            size: 20
          }
        end
      end

      { nodes: nodes, edges: edges }
    end
  end
end
