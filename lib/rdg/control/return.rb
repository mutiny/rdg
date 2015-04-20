require "rdg/analysis/analyser"

module RDG
  module Control
    class Return < Analysis::Analyser
      register_analyser :return

      def analyse(context)
        super
        remove_all_successors
      end
    end
  end
end
