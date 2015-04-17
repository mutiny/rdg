require_relative "analyser"

module RDG
  module Control
    class Propagater < Analyser
      def analyse
        super
        add_internal_flow_edges
        propogate_incoming_flow
        propogate_outgoing_flow
        remove_non_flow_vertices
        add_equivalences
      end

      private

      def children
        @ast_node.children
      end

      def nodes
        children.reject(&:empty?)
      end

      def add_internal_flow_edges
        internal_flow_edges.each { |s, t| @graph.add_edge(s, t) }
      end

      def propogate_incoming_flow
        @graph.each_predecessor(@ast_node) do |predecessor|
          @graph.remove_edge(predecessor, @ast_node)
          @graph.add_edge(predecessor, start_node)
        end
      end

      def propogate_outgoing_flow
        @graph.each_successor(@ast_node) do |successor|
          @graph.remove_edge(@ast_node, successor)
          end_nodes.each { |n| @graph.add_edge(n, successor) }
        end
      end

      def remove_non_flow_vertices
        @graph.remove_vertex(@ast_node)
      end

      def add_equivalences
        @equivalences.add(@ast_node, nodes)
      end
    end
  end
end
