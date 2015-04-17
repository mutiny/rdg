module RDG
  module Control
    class Equivalences
      def initialize
        @equivalences = {}
      end

      def add(original, results)
        @equivalences[original] = results
      end

      def find(original)
        if @equivalences.key?(original)
          find(@equivalences[original])
        else
          original
        end
      end
    end
  end
end
