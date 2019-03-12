RSpec.describe(TaintedLove::Replacer::ReplaceObject) do
  it "replaces send" do
    expect(TaintedLove).to(receive(:report).once)

    1.send("to_s")
    1.send("to_s".taint)
  end
end
