require_relative "analyser"

module RDG
  module Control
    class When < Analyser
      register_analyser :when

      def initialize(ast_node, graph)
        super(ast_node, graph)
        @test, @action = children
      end

      def internal_flow_edges
        [[@test, @action]]
      end

      def start_nodes
        [@test]
      end

      def propogate_outgoing_flow
        successors = @graph.each_successor(@ast_node).to_a
        @graph.add_edge(@test, successors.first)
        @graph.add_edge(@action, successors.last)
      end
    end
  end
end
