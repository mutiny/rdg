require "rgl/adjacency"
require "rgl/dot"
require_relative "rgl/allow_duplicates"

module RDG
  module Graph
    class BidirectedAdjacencyGraph < ::RGL::DirectedAdjacencyGraph
      include RGL::AllowDuplicates

      def each_predecessor(vertex, &block)
        each_vertex.select { |v| each_adjacent(v).include?(vertex) }.each(&block)
      end

      def each_successor(vertex, &block)
        each_adjacent(vertex, &block) if has_vertex?(vertex)
      end
    end
  end
end
