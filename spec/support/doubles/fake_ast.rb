class FakeAst
  attr_accessor :type, :children, :ancestors, :siblings

  def initialize(type, children: [], ancestors: [], siblings: [])
    @type = type
    @children = children
    @ancestors = ancestors
    @siblings = siblings
  end

  def empty?
    false
  end

  def parent
    ancestors.first
  end
end
