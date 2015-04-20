require "rdg/graph/bidirected_adjacency_graph"

module RDG
  module Graph
    describe BidirectedAdjacencyGraph do
      subject do
        BidirectedAdjacencyGraph[
          :f, :b,  #       F
          :b, :a,  #     /   \
          :b, :d,  #    B    G
          :d, :c,  #   / \  /  \
          :d, :e,  #  A   D    I
          :f, :g,  #     / \   /
          :g, :i,  #    C  E  H
          :i, :h,  #
          :g, :d   # NB: edges are directed downwards
        ]
      end

      context "successors" do
        it "should yield a list of successors" do
          expect { |block| subject.each_successor(:b, &block) }.to yield_successive_args(:a, :d)
        end

        it "should not yield for a leaf" do
          expect { |block| subject.each_successor(:c, &block) }.not_to yield_control
        end

        it "should not yield for an unknown node" do
          expect { |block| subject.each_successor(:unknown, &block) }.not_to yield_control
        end
      end

      context "predecessors" do
        it "should yield a list of predecessors" do
          expect { |block| subject.each_predecessor(:d, &block) }.to yield_successive_args(:b, :g)
        end

        it "should not yield for a root" do
          expect { |block| subject.each_predecessor(:f, &block) }.not_to yield_control
        end

        it "should not yield for an unknown node" do
          expect { |block| subject.each_predecessor(:unknown, &block) }.not_to yield_control
        end
      end
    end
  end
end
