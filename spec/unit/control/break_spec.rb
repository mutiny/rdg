require "rdg/control/break"

module RDG
  module Control
    describe Break do
      let(:graph) { spy("graph") }
      let(:equivalences) { spy("equivalences") }
      let(:context) { Analysis::Context.new(graph, equivalences) }

      let(:inside_ast) { FakeAst.new(:send, ancestors: [loop_ast]) }
      let(:outside_ast) { FakeAst.new(:send) }

      let(:loop_ast) { FakeAst.new(:while, children: [:abstract_test]) }
      let(:ast) { FakeAst.new(:thing, ancestors: [loop_ast]) }

      subject { Break.new(ast) }

      it "should use successor of test that are outside the loop as new successors" do
        allow(graph).to receive(:each_successor).with(ast).and_return([])
        allow(equivalences).to receive(:first).with(:abstract_test).and_return(:test)
        allow(graph).to receive(:each_successor).with(:test).and_return([inside_ast, outside_ast])

        subject.analyse(context)

        expect(subject.new_successors).to eq([outside_ast])
      end
    end
  end
end
