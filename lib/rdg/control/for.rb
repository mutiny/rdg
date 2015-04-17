require_relative "propagater"

module RDG
  module Control
    class For < Propagater
      register_analyser :for

      def prepare
        _, @iterable, @body = children
      end

      def internal_flow_edges
        [[@iterable, @body], [@body, @iterable]]
      end

      def start_node
        @iterable
      end

      def end_nodes
        [@iterable]
      end

      def nodes
        [@iterable, @body]
      end
    end
  end
end
