class FakeAst
  attr_reader :type, :children, :ancestors

  def initialize(type, children: [], ancestors: [])
    @type, @children, @ancestors = type, children, ancestors
  end
end
