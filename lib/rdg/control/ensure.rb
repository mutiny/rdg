require_relative "propagater"

module RDG
  module Control
    class Ensure < Propagater
      register_analyser :ensure

      def prepare
        @body, @finaliser = nodes
        customise(@finaliser, Handler)
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
