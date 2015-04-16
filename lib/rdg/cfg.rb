require_relative "rgl/bidirected_adjacency_graph"
require_relative "tree/ast"
require_relative "control/analyser"
require_relative "control/def"
require_relative "control/begin"
require_relative "control/case"
require_relative "control/when"
require_relative "control/if"
require_relative "control/conditional_loop"
require_relative "control/for"
require_relative "control/loop_control"
require_relative "control/rescue"
require_relative "control/rescue_body"
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
      @graph = RDG::RGL::BidirectedAdjacencyGraph.new
      @graph.add_vertex(ast.root)
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
      ast.pre_order_iterator.select(&:compound?).each do |ast_node|
        Control::Analyser.for(ast_node, @graph).analyse
      end
    end
  end
end
