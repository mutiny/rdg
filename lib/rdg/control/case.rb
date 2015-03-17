require_relative "analyser"

module RDG
  module Control
    class Case < Analyser
      register_analyser :case

      def initialize(ast_node, graph, state)
        super(ast_node, graph, state)
        @expression, *@consequences = children.reject(&:empty?)
      end

      def internal_flow_edges
        children.reject(&:empty?).each_cons(2).to_a
      end

      def start_nodes
        [@expression]
      end

      def end_nodes
        @consequences
      end
    end
  end
end
