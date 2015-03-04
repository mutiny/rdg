RSpec::Matchers.define :contain do |*sources|
  match do |graph|
    expected = expected_vertices(sources)
    actual = graph.vertices

    equivalent_ignoring_order(actual, expected)
  end

  failure_message do |graph|
    "expected graph to contain the vertices #{expected_vertices(sources)} " \
    "but got #{graph.vertices}"
  end

  def expected_vertices(sources)
    sources.map { |s| RDG::Tree::AST.from_source(s).root }
  end

  def equivalent_ignoring_order(first_array, second_array)
    first_array.size == second_array.size &&
      first_array.all? { |e| second_array.include?(e) }
  end
end
