require_relative "analyser"

module RDG
  module Control
    class While < Analyser
      register_analyser :while

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
        [@body]
      end
    end
  end
end
