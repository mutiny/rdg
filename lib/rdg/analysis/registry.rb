module RDG
  module Analysis
    class Registry
      def self.register_by_type(analyser, *types)
        types.each { |type| by_type[type] = analyser }
      end

      def self.register_default(analyser)
        by_type.default = analyser
      end

      def self.clear
        by_type.clear
      end

      def analyser_for(ast_node)
        by_node[ast_node]
      end

      def prepend_for(ast_node, analyser)
        by_node[ast_node] = Composite.new(analyser.new(ast_node), by_node[ast_node])
      end

      private

      def self.by_type
        @by_type ||= {}
      end

      def by_node
        @by_node ||= Hash.new { |h, node| h[node] = Registry.by_type[node.type].new(node) }
      end
    end
  end
end
