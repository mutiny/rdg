require_relative "propagater"
require_relative "handler"

module RDG
  module Control
    class Rescue < Propagater
      register_analyser :rescue

      def prepare
        @main, *@handlers, @alternative = children
        @handlers.each { |h| customise(h, Handler) }
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
