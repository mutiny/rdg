require "rdg/cfg"

module RDG
  describe CFG do
    context "for unless expressions" do
      it "should show control flowing from predicate through and around consequence" do
        cfg = CFG.from_source("a = 1; unless b == 1 then; c = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "z = 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
      end

      it "should show control flowing into predicate and through longer consequence" do
        cfg = CFG.from_source("a = 1; unless b == 1 then; c = 1; d = 1; e = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "d = 1", "e = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("c = 1", "d = 1")
        expect(cfg).to flow_between("d = 1", "e = 1")
        expect(cfg).to flow_between("e = 1", "z = 1")
      end

      it "should show control flowing through and around predicate of modifier unless" do
        cfg = CFG.from_source("a = 1; c = 1 unless b == 1; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "z = 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
      end

      it "should show control flowing from predicate to (and out of) all consequences" do
        cfg = CFG.from_source("a = 1; unless b == 1 then; c = 1; else; d = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "d = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("b == 1", "d = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
        expect(cfg).to flow_between("d = 1", "z = 1")
      end
    end
  end
end
