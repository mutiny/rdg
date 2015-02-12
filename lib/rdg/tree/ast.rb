require "rgl/adjacency"
require "rgl/dot"
require "parser/current"
require_relative "rgl/pre_order_iterator"
require_relative "rgl/post_order_iterator"

module RDG
  module Tree
    class AST
      def self.from_path(path, parser = Parser::CurrentRuby)
        from_source(File.read(path), parser)
      end

      def self.from_source(source, parser = Parser::CurrentRuby)
        new(parser.parse(source))
      end

      def initialize(ast)
        @graph = ::RGL::DirectedAdjacencyGraph.new
        import(ast)
      end

      def pre_order_iterator
        RGL::PreOrderIterator.new(@graph)
      end

      def post_order_iterator
        RGL::PostOrderIterator.new(@graph)
      end

      def write_to_graphic_file(format = 'png', filename = "ast")
        @graph.write_to_graphic_file(format, filename)
      end

      private

      def import(ast)
        Node.new(ast).tap do |current_node|
          @graph.add_vertex(current_node)

          current_node.children.each do |child|
            @graph.add_edge(current_node, import(child))
          end
        end
      end

      class Node
        def initialize(wrapped)
          @wrapped = wrapped
        end

        def children
          if @wrapped.is_a?(Parser::AST::Node)
            @wrapped.children
          else
            []
          end
        end

        def to_s
          @wrapped.to_s
        end
      end
    end
  end
end
