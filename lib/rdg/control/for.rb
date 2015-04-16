require_relative "analyser"

module RDG
  module Control
    class For < Analyser
      register_analyser :for

      def initialize(ast_node, graph, equivalences = Equivalences.new)
        super(ast_node, graph, equivalences)
        _, @iterable, @body = children
      end

      def internal_flow_edges
        [[@iterable, @body], [@body, @iterable]]
      end

      def start_nodes
        [@iterable]
      end

      def end_nodes
        [@iterable]
      end
    end
  end
end
