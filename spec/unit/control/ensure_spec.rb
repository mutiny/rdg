require "rdg/control/ensure"

module RDG
  module Control
    describe Ensure do
      let(:registry) { spy('registry') }
      let(:context) { Analysis::Context.new(spy('graph'), spy('equivalences'), registry) }

      let(:main_ast) { FakeAst.new(:if) }
      let(:ensure_ast) { FakeAst.new(:send) }
      let(:ast) { FakeAst.new(:rescue, children: [main_ast, ensure_ast]) }
      subject { Ensure.new(ast) }

      it "should have control flow start at the main block" do
        expect(subject.start_node).to eq(main_ast)
      end

      it "should have control flow end at the ensure block" do
        expect(subject.end_nodes).to eq([ensure_ast])
      end

      it "should have control flow from main block to ensure block" do
        expect(subject.internal_flow_edges).to eq([[main_ast, ensure_ast]])
      end

      it "should prepend Handler so that edges back to main_ast are created for ensure block" do
        subject.analyse(context)

        expect(registry).to have_received(:prepend_for).with(ensure_ast, Handler)
      end
    end
  end
end
