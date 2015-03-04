require_relative "analyser"

module RDG
  module Control
    class Begin < Analyser
      def internal_flow_edges
        children.each_cons(2).to_a
      end

      def start_nodes
        children.first(1)
      end

      def end_nodes
        children.last(1)
      end
    end
  end
end
