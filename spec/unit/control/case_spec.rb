require "rdg/control/case"

module RDG
  module Control
    describe Case do
      context "sole (when) part" do
        let(:ast) { FakeAst.new(:case, children: [:expression, :when, :""]) }
        subject { Case.new(ast) }

        it "should have control flow start at the expression" do
          expect(subject.start_node).to eq(:expression)
        end

        it "should have control flow end at the when part" do
          expect(subject.end_nodes).to eq([:when])
        end

        it "should have control flow edge between expression and when" do
          expect(subject.internal_flow_edges).to eq([[:expression, :when]])
        end
      end

      context "with else part" do
        let(:ast) { FakeAst.new(:case, children: [:expression, :when, :alt]) }
        subject { Case.new(ast) }

        it "should have control flow start at the expression" do
          expect(subject.start_node).to eq(:expression)
        end

        it "should have control flow end at the when and alternative" do
          expect(subject.end_nodes).to eq([:when, :alt])
        end

        it "should have control flow edge from expression to when and then to alternative" do
          expect(subject.internal_flow_edges).to eq([
            [:expression, :when],
            [:when, :alt]
          ])
        end
      end

      context "with several alternatives" do
        let(:ast) { FakeAst.new(:case, children: [:expression, :when1, :when2, :when3, :alt]) }
        subject { Case.new(ast) }

        it "should have control flow start at the expression" do
          expect(subject.start_node).to eq(:expression)
        end

        it "should have control flow end at the whens and alternative" do
          expect(subject.end_nodes).to eq([:when1, :when2, :when3, :alt])
        end

        it "should have control flow edge from expression through whens to alternative" do
          expect(subject.internal_flow_edges).to eq([
            [:expression, :when1],
            [:when1, :when2],
            [:when2, :when3],
            [:when3, :alt]
          ])
        end
      end
    end
  end
end
