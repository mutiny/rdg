require "rdg/tree/ast"

module RDG
  module Tree
    describe AST do
      subject { AST.from_source("a.b") }

      it "should render Ruby source as an AST" do
        nodes = subject.pre_order_iterator.map(&:to_s).to_a

        expect(nodes).to eq(["(send ...)", "(send ...)", "", "a", "b"])
      end
    end
  end
end
