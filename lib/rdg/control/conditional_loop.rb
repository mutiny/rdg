require_relative "analyser"

module RDG
  module Control
    class ConditionalLoop < Analyser
      register_analyser :while, :until

      def initialize(ast_node, graph)
        super(ast_node, graph)
        @predicate, @body = children
      end

      def internal_flow_edges
        [[@predicate, @body], [@body, @predicate]]
      end

      def start_nodes
        [@predicate]
      end

      def end_nodes
        [@predicate]
      end
    end
  end
end
