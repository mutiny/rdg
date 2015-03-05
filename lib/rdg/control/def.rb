module RDG
  module Control
    class Def < Analyser
      register_analyser :def

      def initialize(ast_node, graph, state)
        @graph, @state = graph, state
        @name, @args, @body = ast_node.children
      end

      def analyse
        @state[:current_method] = @name
        @graph.add_edge(@name, @body)
      end
    end
  end
end
