require "rdg/tree/rgl/post_order_iterator"
require "rgl/adjacency"

module RDG
  module Tree
    module RGL
      describe PostOrderIterator do
        let(:tree) do
          ::RGL::DirectedAdjacencyGraph[
            :f, :b,  #       F
            :b, :a,  #     /   \
            :b, :d,  #    B    G
            :d, :c,  #   / \    \
            :d, :e,  #  A   D    I
            :f, :g,  #     / \   /
            :g, :i,  #    C  E  H
            :i, :h   #
          ]
        end
        let(:post_order_traversal) { %i(a c e d b h i g f) }
        subject { PostOrderIterator.new(tree) }

        it "should return a correct post-order traversal" do
          expect(subject.to_a).to eq(post_order_traversal)
        end

        it "should return a correct post-order traversal when iterated backwards" do
          backwards = []
          subject.set_to_end
          backwards << subject.basic_backward until subject.at_beginning?

          expect(backwards).to eq(post_order_traversal.reverse)
        end
      end
    end
  end
end
