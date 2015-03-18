require "rdg/cfg"

module RDG
  describe CFG do
    %w(while until).each do |kind|
      context "for simple #{kind} expressions" do
        it "should show control flowing between test and body, and out to successor" do
          cfg = CFG.from_source("a = 1; #{kind} true do; a += 1; end; z = 1")

          expect(cfg).to contain("a = 1", "true", "a += 1", "z = 1")

          expect(cfg).to flow_between("a = 1", "true")
          expect(cfg).to flow_between("true", "a += 1")
          expect(cfg).to flow_between("true", "z = 1")
          expect(cfg).to flow_between("a += 1", "true")
        end

        it "should show control flowing through longer body" do
          cfg = CFG.from_source("a = 1; #{kind} true do; a += 1; b += 1; c += 1; end; z = 1")

          expect(cfg).to contain("a = 1", "true", "a += 1", "b += 1", "c += 1", "z = 1")

          expect(cfg).to flow_between("a = 1", "true")
          expect(cfg).to flow_between("true", "a += 1")
          expect(cfg).to flow_between("true", "z = 1")
          expect(cfg).to flow_between("a += 1", "b += 1")
          expect(cfg).to flow_between("b += 1", "c += 1")
          expect(cfg).to flow_between("c += 1", "true")
        end

        it "should show control flowing between test and body for modifier #{kind}" do
          cfg = CFG.from_source("a = 1; b += 1 #{kind} true; z = 1")

          expect(cfg).to contain("a = 1", "b += 1", "true", "z = 1")

          expect(cfg).to flow_between("a = 1", "true")
          expect(cfg).to flow_between("true", "b +=1")
          expect(cfg).to flow_between("true", "z = 1")
          expect(cfg).to flow_between("b += 1", "true")
        end
      end
    end

    context "for simple for expressions" do
      it "should show control flowing between test and body, and out to successor" do
        cfg = CFG.from_source("a = 1; for i in [1,2,3] do; a += 1; end; z = 1")

        expect(cfg).to contain("a = 1", "[1,2,3]", "a += 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "[1,2,3]")
        expect(cfg).to flow_between("[1,2,3]", "a += 1")
        expect(cfg).to flow_between("[1,2,3]", "z = 1")
        expect(cfg).to flow_between("a += 1", "[1,2,3]")
      end

      it "should show control flowing through longer body" do
        cfg = CFG.from_source("a = 1; for i in [1,2,3] do; a += 1; b += 1; c += 1; end; z = 1")

        expect(cfg).to contain("a = 1", "[1,2,3]", "a += 1", "b += 1", "c += 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "[1,2,3]")
        expect(cfg).to flow_between("[1,2,3]", "a += 1")
        expect(cfg).to flow_between("[1,2,3]", "z = 1")
        expect(cfg).to flow_between("a += 1", "b += 1")
        expect(cfg).to flow_between("b += 1", "c += 1")
        expect(cfg).to flow_between("c += 1", "[1,2,3]")
      end
    end
  end
end
