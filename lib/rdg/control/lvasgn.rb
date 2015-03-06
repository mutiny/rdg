require_relative "analyser"

module RDG
  module Control
    class Lvasgn < Analyser
      register_analyser :lvasgn

      def analyse
        @graph.add_vertex(@ast_node)
      end
    end
  end
end
