RSpec.describe(TaintedLove::Replacer::ReplaceObject) do
  it "replaces send" do
    expect(TaintedLove).to(receive(:report).once)

    instance = Class.new {
      def methods_missing(*args, &block)
      end
    }.new

    expect(instance).to(receive(:method).exactly(3).times)

    instance.send("method", "static")
    instance.send("method".taint, "static")
    instance.send("method".taint, "tainted".taint)
  end
end
