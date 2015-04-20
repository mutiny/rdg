require_relative "../rgl/bidirected_adjacency_graph"
require_relative "equivalences"
require_relative "registry"

module RDG
  module Control
    class Context
      attr_reader :graph, :equivalences, :registry

      def initialize(graph = nil, equivalences = nil, registry = nil)
        @graph = graph || RDG::RGL::BidirectedAdjacencyGraph.new
        @equivalences = equivalences || Equivalences.new
        @registry = registry || Registry.new
      end
    end
  end
end
