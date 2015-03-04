RSpec::Matchers.define :flow_between do |source_of_start, source_of_end|
  match do |graph|
    graph.has_edge?(
      find_vertex(graph, source_of_start),
      find_vertex(graph, source_of_end)
    )
  end

  failure_message do |graph|
    "expected to find an edge from #{source_of_start} to #{source_of_end} " \
    "but from #{source_of_start} the only edges are: " \
    "#{graph.successors(find_vertex(graph, source_of_start))}"
  end

  def find_vertex(graph, source)
    graph.vertices.detect { |v| v == RDG::Tree::AST.from_source(source).root }
  end
end
