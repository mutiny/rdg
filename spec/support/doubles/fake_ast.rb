class FakeAst
  attr_accessor :type, :children, :ancestors, :siblings

  def initialize(type, children: [], ancestors: [], siblings: [])
    @type, @children, @ancestors, @siblings = type, children, ancestors, siblings
  end

  def empty?
    false
  end
end
