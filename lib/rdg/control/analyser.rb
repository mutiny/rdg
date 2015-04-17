require_relative "equivalences"

module RDG
  module Control
    class Analyser
      ANALYSERS = {}

      def self.register_analyser(*types)
        types.each { |type| ANALYSERS[type] = self }
      end

      def self.register_default_analyser
        ANALYSERS.default = self
      end

      def self.for(ast_node, graph, equivalences)
        ANALYSERS[ast_node.type].new(ast_node, graph, equivalences)
      end

      def initialize(ast_node, graph, equivalences = Equivalences.new)
        @ast_node, @graph, @equivalences = ast_node, graph, equivalences
        prepare
      end

      def prepare # make private?
      end

      def analyse
        run_customisations
      end

      private

      def customise(node, customisation)
        Analyser.customisations[node] = customisation
      end

      def run_customisations
        return unless Analyser.customisations.key?(@ast_node)
        Analyser.customisations[@ast_node].new(@ast_node, @graph, @equivalences).analyse
      end

      def self.customisations
        @customisations ||= {}
      end
    end
  end
end
