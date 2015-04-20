require "rdg/analysis/propagater"

module RDG
  module Control
    class ConditionalLoop < Analysis::Propagater
      register_analyser :while, :until

      def prepare
        @predicate, @body = nodes
      end

      def internal_flow_edges
        [[@predicate, @body], [@body, @predicate]]
      end

      def start_node
        @predicate
      end

      def end_nodes
        [@predicate]
      end
    end
  end
end
