require "rdg/control/begin"

module RDG
  module Control
    describe Equivalences do
      let(:ast) { FakeAst.new(:begin, children: [1, 2, 3]) }

      context "all" do
        it "returns direct equivalents" do
          subject.add(:if, [:predicate, :consequence])

          expect(subject.all(:if)).to eq([:predicate, :consequence])
        end

        it "returns indirect equivalents transitively" do
          subject.add(:if, [:predicate, :consequence])
          subject.add(:predicate, [:send, :float])
          subject.add(:consequence, [:return])

          expect(subject.all(:if)).to eq([:send, :float, :return])
        end

        it "returns the original when there is no equivalent" do
          expect(subject.first(:if)).to eq(:if)
        end
      end
    end
  end
end
