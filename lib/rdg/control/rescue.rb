require "rdg/analysis/propagater"
require_relative "handler"

module RDG
  module Control
    class Rescue < Analysis::Propagater
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

      def add_extra_analysers
        @handlers.each { |h| registry.prepend_for(h, Handler) }
      end
    end
  end
end
