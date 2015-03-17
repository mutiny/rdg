require "rdg/cfg"

module RDG
  describe CFG do
    context "for simple if expressions" do
      it "should show control flowing from predicate through and around consequence" do
        cfg = CFG.from_source("a = 1; if b == 1 then; c = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "z = 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
      end

      it "should show control flowing into predicate and through longer consequence" do
        cfg = CFG.from_source("a = 1; if b == 1 then; c = 1; d = 1; e = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "d = 1", "e = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("c = 1", "d = 1")
        expect(cfg).to flow_between("d = 1", "e = 1")
        expect(cfg).to flow_between("e = 1", "z = 1")
      end

      it "should show control flowing through and around predicate of modifier if" do
        cfg = CFG.from_source("a = 1; c = 1 if b == 1; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "z = 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
      end
    end

    context "for if expressions with several consequences" do
      it "should show control flowing from predicate to (and out of) all consequences" do
        cfg = CFG.from_source("a = 1; if b == 1 then; c = 1; else; d = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "d = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("b == 1", "d = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
        expect(cfg).to flow_between("d = 1", "z = 1")
      end

      it "should show control flowing over each condition and its consequences" do
        cfg = CFG.from_source("a = 1;" \
                              "if b == 1 then; c = 1; elsif b == 2; d = 1; else; e = 1; end;" \
                              "z = 1")

        expect(cfg).to contain("a = 1", "b == 1", "c = 1", "b == 2", "d = 1", "e = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b == 1")
        expect(cfg).to flow_between("b == 1", "c = 1")
        expect(cfg).to flow_between("b == 1", "b == 2")
        expect(cfg).to flow_between("b == 2", "d = 1")
        expect(cfg).to flow_between("b == 2", "e = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
        expect(cfg).to flow_between("d = 1", "z = 1")
        expect(cfg).to flow_between("e = 1", "z = 1")
      end

      it "should show control flowing from predicate to both consequences of ternary" do
        cfg = CFG.from_source("a = 1; b == 1 ? c = 1 : d = 1; z = 1")

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
