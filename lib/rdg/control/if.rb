require "rdg/analysis/propagater"

module RDG
  module Control
    class If < Analysis::Propagater
      register_analyser :if

      def prepare
        @predicate, *@consequences = nodes
      end

      def internal_flow_edges
        @consequences.map { |consequence| [@predicate, consequence] }
      end

      def start_node
        @predicate
      end

      def end_nodes
        if @consequences.size == 1
          [@predicate, @consequences.first]
        else
          @consequences
        end
      end
    end
  end
end
