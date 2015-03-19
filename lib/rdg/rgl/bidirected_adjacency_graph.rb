require "rgl/adjacency"
require "rgl/dot"

module RDG
  module RGL
    class BidirectedAdjacencyGraph < ::RGL::DirectedAdjacencyGraph
      def each_predecessor(vertex, &block)
        each_vertex.select { |v| each_adjacent(v).include?(vertex) }.each(&block)
      end

      def each_successor(vertex, &block)
        each_adjacent(vertex, &block) if has_vertex?(vertex)
      end
    end
  end
end
