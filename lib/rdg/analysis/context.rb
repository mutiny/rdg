require_relative "../graph/bidirected_adjacency_graph"
require_relative "equivalences"
require_relative "registry"

module RDG
  module Analysis
    class Context
      attr_reader :graph, :equivalences, :registry

      def initialize(graph = nil, equivalences = nil, registry = nil)
        @graph = graph || Graph::BidirectedAdjacencyGraph.new
        @equivalences = equivalences || Equivalences.new
        @registry = registry || Registry.new
      end
    end
  end
end
