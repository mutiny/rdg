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
          @equivalences[original].map { |result| find(result) }.flatten
        else
          [original]
        end
      end
    end
  end
end
