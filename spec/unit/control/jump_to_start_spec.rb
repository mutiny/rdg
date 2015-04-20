require "rdg/control/jump_to_start"

module RDG
  module Control
    describe JumpToStart do
      let(:graph) { spy("graph") }
      let(:equivalences) { spy("equivalences") }
      let(:context) { Analysis::Context.new(graph, equivalences) }

      let(:block_ast) { FakeAst.new(:while, children: [:jumpable]) }
      let(:ast) { FakeAst.new(:thing, ancestors: [block_ast]) }

      subject { JumpToStart.new(ast, context) }

      it "should use equivalents of block's first child as new successors" do
        allow(equivalences).to receive(:first).with(:jumpable).and_return(:new_successor)

        expect(subject.new_successors).to eq([:new_successor])
      end
    end
  end
end
