require "rdg/control/rescue"

module RDG
  module Control
    describe Rescue do
      let(:registry) { spy('registry') }
      let(:context) { Analysis::Context.new(spy('graph'), spy('equivalences'), registry) }

      let(:main_ast) { FakeAst.new(:if) }
      let(:handler1) { FakeAst.new(:send) }
      let(:handler2) { FakeAst.new(:raise) }

      context "rescue without an else" do
        let(:ast) { FakeAst.new(:rescue, children: [main_ast, handler1, handler2, :""]) }
        subject { Rescue.new(ast) }

        it "should have control flow start at the main block" do
          expect(subject.start_node).to eq(main_ast)
        end

        it "should have control flow end at the main block and each fallback" do
          expect(subject.end_nodes).to eq([main_ast, handler1, handler2])
        end

        it "should have no control flow edges (yet)" do
          expect(subject.internal_flow_edges).to eq([])
        end

        it "should prepend Handler so that edges back to main_ast are created for each handler" do
          subject.analyse(context)

          expect(registry).to have_received(:prepend_for).with(handler1, Handler)
          expect(registry).to have_received(:prepend_for).with(handler2, Handler)
        end
      end

      context "rescue with an else" do
        let(:ast) { FakeAst.new(:rescue, children: [main_ast, handler1, handler2, :else]) }
        subject { Rescue.new(ast) }

        it "should have control flow start at the main block" do
          expect(subject.start_node).to eq(main_ast)
        end

        it "should have control flow end at each fallback and the else" do
          expect(subject.end_nodes).to eq([handler1, handler2, :else])
        end

        it "should have control flow from the main block to the else and nothing more (yet)" do
          expect(subject.internal_flow_edges).to eq([[main_ast, :else]])
        end

        it "should prepend Handler so that edges back to main_ast are created for each handler" do
          subject.analyse(context)

          expect(registry).to have_received(:prepend_for).with(handler1, Handler)
          expect(registry).to have_received(:prepend_for).with(handler2, Handler)
        end
      end
    end
  end
end
