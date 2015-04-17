require_relative "analyser"

module RDG
  module Control
    class Rescue < Analyser
      register_analyser :rescue

      def prepare
        @main, *@fallbacks = children.reject(&:empty?)
      end

      def internal_flow_edges
        if @main.type == :begin
          @main.children.product(@fallbacks)
        else
          [@main].product(@fallbacks)
        end
      end

      def start_node
        @main
      end

      def end_nodes
        [@main] + @fallbacks
      end
    end
  end
end
