require_relative "analyser"

module RDG
  module Control
    class If < Analyser
      def initialize(ast_node, graph, state)
        super(ast_node, graph, state)
        @predicate, *@consequences = children.reject(&:empty?)
      end

      def internal_flow_edges
        @consequences.map { |consequence| [@predicate, consequence] }
      end

      def start_nodes
        [@predicate]
      end

      def end_nodes
        if @consequences.size == 1
          [@predicate, @consequences.first]
        else
          @consequences
        end
      end
    end
  end
end