require "rdg/analysis/propagater"

module RDG
  module Control
    class Case < Analysis::Propagater
      register_analyser :case

      def prepare
        @expression, *@consequences = nodes
      end

      def internal_flow_edges
        nodes.each_cons(2).to_a
      end

      def start_node
        @expression
      end

      def end_nodes
        @consequences
      end
    end
  end
end
