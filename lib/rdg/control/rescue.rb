require_relative "analyser"

module RDG
  module Control
    class Rescue < Analyser
      register_analyser :rescue

      def internal_flow_edges
        []
      end

      def start_node
        children.first
      end

      def end_nodes
        nodes
      end
    end
  end
end
