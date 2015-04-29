require "rdg/control/when"

module RDG
  module Control
    describe When do
      let(:ast) { FakeAst.new(:when, children: [:test, :action]) }
      let(:graph) { spy("graph") }
      let(:context) { Analysis::Context.new(graph) }
      subject { When.new(ast) }

      context "two successors" do
        before(:each) do
          allow(graph).to receive(:each_successor).with(ast) { [:next_when, :successor] }
          subject.analyse(context)
        end

        it "should have control flow start at the expression" do
          expect(subject.start_node).to eq(:test)
        end

        it "should have control flow edge between test and action" do
          expect(subject.internal_flow_edges).to eq([[:test, :action]])
        end

        it "should propagate outgoing flow from test to next when" do
          expect(graph).to have_received(:add_edge).with(:test, :next_when)
        end

        it "should propagate outgoing flow from action to successor" do
          expect(graph).to have_received(:add_edge).with(:action, :successor)
        end
      end

      context "one successor" do
        before(:each) do
          allow(graph).to receive(:each_successor).with(ast) { [:successor] }
          subject.analyse(context)
        end

        it "should have control flow start at the expression" do
          expect(subject.start_node).to eq(:test)
        end

        it "should have control flow edge between test and action" do
          expect(subject.internal_flow_edges).to eq([[:test, :action]])
        end

        it "should propagate outgoing flow from test to successor" do
          expect(graph).to have_received(:add_edge).with(:test, :successor)
        end

        it "should propagate outgoing flow from action to successor" do
          expect(graph).to have_received(:add_edge).with(:action, :successor)
        end
      end
    end
  end
end
