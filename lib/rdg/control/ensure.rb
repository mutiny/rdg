require "rdg/analysis/propagater"

module RDG
  module Control
    class Ensure < Analysis::Propagater
      register_analyser :ensure

      def prepare
        @body, @finaliser = nodes
      end

      def analyse
        super
        registry.prepend_for(@finaliser, Handler)
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
    end
  end
end
