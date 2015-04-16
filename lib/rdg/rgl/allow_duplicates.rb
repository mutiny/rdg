require "rgl/dot"

# This module provides a workaround for RGL issue #15:
# https://github.com/monora/rgl/issues/15
#
# Once the fix appears in an RGL release, this module
# and any includes of this module can be safely removed.

# rubocop:disable all
module RDG
  module RGL
    module AllowDuplicates
      def to_dot_graph(params = {})
        params['name'] ||= self.class.name.gsub(/:/, '_')
        fontsize       = params['fontsize'] ? params['fontsize'] : '8'
        graph          = (directed? ? ::RGL::DOT::Digraph : ::RGL::DOT::Graph).new(params)
        edge_class     = directed? ? ::RGL::DOT::DirectedEdge : ::RGL::DOT::Edge

        each_vertex do |v|
          graph << ::RGL::DOT::Node.new(
              'name'     => v.object_id,
              'fontsize' => fontsize,
              'label'    => vertex_label(v)
          )
        end

        each_edge do |u, v|
          graph << edge_class.new(
              'from'     => u.object_id,
              'to'       => v.object_id,
              'fontsize' => fontsize
          )
        end

        graph
      end
      
      # Returns a label for vertex v. Default is v.to_s
      def vertex_label(v)
        v.to_s
      end
    end
  end
end
# rubocop:enable all
