module RDG
  module Control
    class Analyser
      def initialize(ast_node, graph, state)
        @ast_node, @graph, @state = ast_node, graph, state
      end

      def analyse
        add_internal_flow_edges
        propogate_incoming_flow
        propogate_outgoing_flow
        remove_non_flow_vertices
      end

      private

      def children
        @ast_node.children
      end

      def add_internal_flow_edges
        internal_flow_edges.each { |s, t| @graph.add_edge(s, t) }
      end

      def propogate_incoming_flow
        @graph.each_predecessor(@ast_node) do |predecessor|
          @graph.remove_edge(predecessor, @ast_node)
          start_nodes.each { |n| @graph.add_edge(predecessor, n) }
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
    end
  end
end
