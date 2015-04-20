require "rdg/control/break"

module RDG
  module Control
    describe Break do
      let(:graph) { spy("graph") }
      let(:equivalences) { spy("equivalences") }
      let(:context) { Context.new(graph, equivalences) }

      let(:inside_ast) { FakeAst.new(:send, ancestors: [loop_ast]) }
      let(:outside_ast) { FakeAst.new(:send) }

      let(:loop_ast) { FakeAst.new(:while, children: [:abstract_test]) }
      let(:ast) { FakeAst.new(:thing, ancestors: [loop_ast]) }

      subject { Break.new(ast, context) }

      it "should use successor of test that are outside the loop as new successors" do
        allow(equivalences).to receive(:first).with(:abstract_test).and_return(:test)
        allow(graph).to receive(:each_successor).with(:test).and_return([inside_ast, outside_ast])

        expect(subject.new_successors).to eq([outside_ast])
      end
    end
  end
end
