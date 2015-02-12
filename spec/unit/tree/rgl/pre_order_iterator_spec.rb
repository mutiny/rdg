require "rdg/tree/rgl/pre_order_iterator"
require "rgl/adjacency"

module RDG
  module Tree
    module RGL
      describe PreOrderIterator do
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
        let(:pre_order_traversal) { %i(f b a d c e g i h) }
        subject { PreOrderIterator.new(tree) }

        it "should return a correct pre-order traversal" do
          expect(subject.to_a).to eq(pre_order_traversal)
        end

        it "should return a correct pre-order traversal when iterated backwards" do
          backwards = []
          subject.set_to_end
          backwards << subject.basic_backward until subject.at_beginning?

          expect(backwards).to eq(pre_order_traversal.reverse)
        end
      end
    end
  end
end
