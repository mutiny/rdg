require "rdg/analysis/propagater"

module RDG
  module Control
    class Ensure < Analysis::Propagater
      register_analyser :ensure

      def prepare
        @body, @finaliser = nodes
      end

      def internal_flow_edges
        [[@body, @finaliser]]
      end

      def start_node
        @body
      end

      def end_nodes
        [@finaliser]
      end

      def add_extra_analysers
        registry.prepend_for(@finaliser, Handler)
      end
    end
  end
end
