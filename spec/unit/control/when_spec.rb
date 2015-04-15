require "rdg/control/when"

module RDG
  module Control
    describe When do
      let(:ast) { FakeAst.new(:when, children: [:test, :action]) }
      let(:graph) { spy("graph") }
      subject { When.new(ast, graph) }

      context "two successors" do
        before(:each) do
          allow(graph).to receive(:each_successor).with(ast) { [:next_when, :successor] }
        end

        it "should have control flow start at the expression" do
          expect(subject.start_nodes).to eq([:test])
        end

        it "should have control flow edge between test and action" do
          expect(subject.internal_flow_edges).to eq([[:test, :action]])
        end

        it "should propagate outgoing flow from test to next when" do
          subject.propogate_outgoing_flow
          expect(graph).to have_received(:add_edge).with(:test, :next_when)
        end

        it "should propagate outgoing flow from action to successor" do
          subject.propogate_outgoing_flow
          expect(graph).to have_received(:add_edge).with(:action, :successor)
        end
      end

      context "one successor" do
        before(:each) do
          allow(graph).to receive(:each_successor).with(ast) { [:successor] }
        end

        it "should have control flow start at the expression" do
          expect(subject.start_nodes).to eq([:test])
        end

        it "should have control flow edge between test and action" do
          expect(subject.internal_flow_edges).to eq([[:test, :action]])
        end

        it "should propagate outgoing flow from test to successor" do
          subject.propogate_outgoing_flow
          expect(graph).to have_received(:add_edge).with(:test, :successor)
        end

        it "should propagate outgoing flow from action to successor" do
          subject.propogate_outgoing_flow
          expect(graph).to have_received(:add_edge).with(:action, :successor)
        end
      end
    end
  end
end
