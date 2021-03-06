require "rdg/analysis/propagater"

module RDG
  module Control
    class When < Analysis::Propagater
      register_analyser :when

      def prepare
        @test, @action = nodes
      end

      def internal_flow_edges
        [[@test, @action]]
      end

      def start_node
        @test
      end

      def propogate_outgoing_flow
        successors = graph.each_successor(@ast_node).to_a
        graph.add_edge(@test, successors.first)
        graph.add_edge(@action, successors.last)
      end
    end
  end
end
