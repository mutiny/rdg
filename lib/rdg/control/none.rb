require "rdg/analysis/analyser"

module RDG
  module Control
    class None < Analysis::Analyser
      register_default_analyser
    end
  end
end
