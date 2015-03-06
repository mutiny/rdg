require_relative "tree/ast"
require_relative "control/analyser"
require_relative "control/def"
require_relative "control/begin"
require_relative "control/if"
require_relative "control/while"
require_relative "control/return"
require_relative "control/none"

module RDG
  class CFG
    def self.from_path(path)
      new(Tree::AST.from_path(path))
    end

    def self.from_source(source)
      new(Tree::AST.from_source(source))
    end

    def initialize(ast)
      @graph = BiDiDirectedAdjacencyGraph.new
      analyse(ast)
    end

    def write_to_graphic_file(format = 'png', filename = "cfg")
      @graph.write_to_graphic_file(format, filename)
    end

    def vertices
      @graph.each_vertex.to_a
    end

    def successors(v)
      @graph.each_adjacent(v).to_a
    end

    def edge?(u, v)
      @graph.has_edge?(u, v)
    end

    private

    def analyse(ast)
      state = {}
      ast.pre_order_iterator.select(&:compound?).each do |ast_node|
        Control::Analyser.for(ast_node, @graph, state).analyse
      end
    end

    class BiDiDirectedAdjacencyGraph < ::RGL::DirectedAdjacencyGraph
      def each_predecessor(vertex, &block)
        each_vertex.select { |v| each_adjacent(v).include?(vertex) }.each(&block)
      end

      def each_successor(vertex, &block)
        each_adjacent(vertex, &block) if has_vertex?(vertex)
      end
    end
  end
end
