require_relative "analyser"

module RDG
  module Control
    class Rescue < Analyser
      register_analyser :rescue

      def prepare
        @main, *@handlers, @alternative = children
      end

      def internal_flow_edges
        @alternative.empty? ? [] : [[@main, @alternative]]
      end

      def start_node
        @main
      end

      def end_nodes
        @alternative.empty? ? nodes : @handlers.push(@alternative)
      end
    end
  end
end
