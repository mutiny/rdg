require "rdg/control/begin"

module RDG
  module Control
    describe Equivalences do
      let(:ast) { FakeAst.new(:begin, children: [1, 2, 3]) }

      it "finds direct equivalent" do
        subject.add(:if, :test)
        expect(subject.find(:if)).to eq(:test)
      end

      it "finds indirect equivalent transitively" do
        subject.add(:if, :send)
        subject.add(:send, :test)
        expect(subject.find(:if)).to eq(:test)
      end

      it "returns the original when there is no equivalent" do
        expect(subject.find(:if)).to eq(:if)
      end
    end
  end
end
