require "rdg/cfg"

module RDG
  describe CFG do
    context "for simple loop control expressions" do
      it "should show control flowing from break directly to successor" do
        cfg = CFG.from_source("a = 1; while true do; a += 1; break; b += 1; end; z = 1")

        expect(cfg).to contain("a = 1", "true", "a += 1", "break", "b += 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "true")
        expect(cfg).to flow_between("true", "a += 1")
        expect(cfg).to flow_between("true", "z = 1")
        expect(cfg).to flow_between("a += 1", "break")
        expect(cfg).to flow_between("break", "z = 1")
        expect(cfg).to flow_between("b += 1", "true")

        expect(cfg).not_to flow_between("break", "a += 1")
      end

      it "should show control flowing from nested break only to successor" do
        cfg = CFG.from_source("a = 1; while true do; a += 1; break if false; b += 1; end; z = 1")

        expect(cfg).to contain("a = 1", "true", "a += 1", "break", "false", "b += 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "true")
        expect(cfg).to flow_between("true", "a += 1")
        expect(cfg).to flow_between("true", "z = 1")
        expect(cfg).to flow_between("a += 1", "false")
        expect(cfg).to flow_between("false", "break")
        expect(cfg).to flow_between("false", "b += 1")
        expect(cfg).to flow_between("break", "z = 1")
        expect(cfg).to flow_between("b += 1", "true")

        expect(cfg).not_to flow_between("break", "a += 1")
      end

      %w(next redo).each do |kind|
        it "should show control flowing from #{kind} directly to test" do
          cfg = CFG.from_source("a = 1; while true do; a += 1; #{kind}; b += 1; end; z = 1")

          expect(cfg).to contain("a = 1", "true", "a += 1", "#{kind}", "b += 1", "z = 1")

          expect(cfg).to flow_between("a = 1", "true")
          expect(cfg).to flow_between("true", "a += 1")
          expect(cfg).to flow_between("true", "z = 1")
          expect(cfg).to flow_between("a += 1", "#{kind}")
          expect(cfg).to flow_between("#{kind}", "true")
          expect(cfg).to flow_between("b += 1", "true")
        end
      end
    end

    context "for nested loop control expressions" do
      it "should show control flowing from break to inner loop's successor" do
        cfg = CFG.from_source("while false do;" \
                              "a = 1; while true do; a += 1; break; b += 1; end; z = 1;" \
                              "end;" \
                              "final = 1")

        expect(cfg).to flow_between("break", "z = 1")
        expect(cfg).not_to flow_between("break", "final = 1")
      end

      %w(next redo).each do |kind|
        it "should show control flowing from #{kind} to inner loop's test" do
          cfg = CFG.from_source("while false do;" \
                                "a = 1; while true do; a += 1; #{kind}; b += 1; end; z = 1;" \
                                "end;" \
                                "final = 1")

          expect(cfg).to flow_between("#{kind}", "true")
          expect(cfg).not_to flow_between("#{kind}", "false")
        end
      end
    end

    context "for complex loop test" do
      %w(next redo).each do |kind|
        it "should show control flow from #{kind} to children of inner loop's test" do
          cfg = CFG.from_source("a = 1;" \
                                "while 42 ? :foo : 'bar' do; a += 1; #{kind}; b += 1; end;" \
                                "z = 1;")

          expect(cfg).to flow_between("#{kind}", "42")
        end
      end
    end
  end
end
