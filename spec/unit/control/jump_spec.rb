require "rdg/control/jump"

module RDG
  module Control
    describe Jump do
      let(:graph) { spy("graph") }
      let(:context) { Analysis::Context.new(graph) }
      let(:block_ast) { FakeAst.new(:while) }
      let(:ast) { FakeAst.new(:thing, ancestors: [block_ast]) }

      subject do
        class DummyJump < Jump
          def new_successors
            %i(first_new_successor second_new_successor)
          end
        end

        DummyJump.new(ast)
      end

      it "should remove any edges to existing successors" do
        allow(graph).to receive(:each_successor).and_yield(:successor)
        subject.analyse(context)

        expect(graph).to have_received(:remove_edge).with(ast, :successor)
      end

      it "should add an edge from jump to each new successor" do
        subject.analyse(context)

        expect(graph).to have_received(:add_edge).with(ast, :first_new_successor)
        expect(graph).to have_received(:add_edge).with(ast, :second_new_successor)
      end

      it "should do nothing when not contained within a block" do
        ast.ancestors = []
        subject.analyse(context)

        expect(graph).not_to have_received(:add_edge)
        expect(graph).not_to have_received(:remove_edge)
      end
    end
  end
end
