class PreOrderIterator
  include RGL::GraphIterator

  def initialize(tree, root = tree.first)
    super(tree)
    @root = root
    set_to_begin
  end

  def set_to_begin
    @visited = Hash.new(false)
    @stack = []
    @start = @root
    @current = @start
  end

  def at_beginning?
    @current == @start
  end

  def at_end?
    visited?(last_leaf(@root))
  end

  def basic_forward
    @current = descend(@current)
    visit(@current)
    @current
  end

  def basic_backward
    @current = ascend(@current)
    unvisit(@current)
    @current
  end

  private

  def visit(node)
    @visited[node.object_id] = true
  end

  def unvisit(node)
    @visited[node.object_id] = false
  end

  def visited?(node)
    @visited[node.object_id]
  end

  def descend(node)
    next_child = graph.each_adjacent(node).detect { |c| !visited?(c) }

    if !visited?(node)
      node
    elsif next_child.nil?
      descend(@stack.pop)
    else
      @stack.push(node)
      next_child
    end
  end

  def ascend(node)
    last_child = graph.each_adjacent(node).select { |c| visited?(c) }.last

    if last_child
      @stack.push(node)
      ascend(last_child)
    elsif visited?(node)
      node
    else
      ascend(@stack.pop)
    end
  end

  def last_leaf(node)
    last_child = graph.each_adjacent(node).select { |_c| true }.last

    if last_child.nil?
      node
    else
      last_leaf(last_child)
    end
  end
end
