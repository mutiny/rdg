require "rdg/control/rescue"

module RDG
  module Control
    describe Rescue do
      let(:main_ast) { FakeAst.new(:if) }
      let(:ast) { FakeAst.new(:rescue, children: [main_ast, :first_handler, :second_handler]) }
      subject { Rescue.new(ast, nil) }

      it "should have control flow start at the main block" do
        expect(subject.start_node).to eq(main_ast)
      end

      it "should have control flow end at the main block and each fallback" do
        expect(subject.end_nodes).to eq([main_ast, :first_handler, :second_handler])
      end

      it "should have no control flow edges (yet)" do
        expect(subject.internal_flow_edges).to eq([])
      end
    end
  end
end
