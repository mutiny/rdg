require "rdg/control/if"

module RDG
  module Control
    describe If do
      context "without any alternatives" do
        let(:ast) { FakeAst.new(:if, children: [:predicate, :consequence, :""]) }
        subject { If.new(ast) }

        it "should have control flow start at the predicate" do
          expect(subject.start_node).to eq(:predicate)
        end

        it "should have control flow end at the predicate and the consequence" do
          expect(subject.end_nodes).to eq([:predicate, :consequence])
        end

        it "should have control flow edge between predicate and consequence" do
          expect(subject.internal_flow_edges).to eq([[:predicate, :consequence]])
        end
      end

      context "without any consequence (i.e., the `parser` gem's representation of unless)" do
        let(:ast) { FakeAst.new(:if, children: [:predicate, :"", :alternative]) }
        subject { If.new(ast) }

        it "should have control flow start at the predicate" do
          expect(subject.start_node).to eq(:predicate)
        end

        it "should have control flow end at the predicate and the alternative" do
          expect(subject.end_nodes).to eq([:predicate, :alternative])
        end

        it "should have control flow edge between predicate and alternative" do
          expect(subject.internal_flow_edges).to eq([[:predicate, :alternative]])
        end
      end

      context "with one alternative" do
        let(:ast) { FakeAst.new(:if, children: [:predicate, :consequence, :alternative]) }
        subject { If.new(ast) }

        it "should have control flow start at the predicate" do
          expect(subject.start_node).to eq(:predicate)
        end

        it "should have control flow end at the consequences" do
          expect(subject.end_nodes).to eq([:consequence, :alternative])
        end

        it "should have control flow edge between predicate and consequences" do
          expect(subject.internal_flow_edges).to eq([
            [:predicate, :consequence],
            [:predicate, :alternative]
          ])
        end
      end

      context "with several alternatives" do
        let(:ast) { FakeAst.new(:if, children: [:predicate, :consequence, :a1, :a2, :a3]) }
        subject { If.new(ast) }

        it "should have control flow start at the predicate" do
          expect(subject.start_node).to eq(:predicate)
        end

        it "should have control flow end at the consequences" do
          expect(subject.end_nodes).to eq([:consequence, :a1, :a2, :a3])
        end

        it "should have control flow edge between predicate and all consequences" do
          expect(subject.internal_flow_edges).to eq([
            [:predicate, :consequence],
            [:predicate, :a1],
            [:predicate, :a2],
            [:predicate, :a3]
          ])
        end
      end
    end
  end
end
