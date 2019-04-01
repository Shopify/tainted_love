RSpec.describe(TaintedLove::Replacer::ReplaceFile) do
  it "taints the output only if the input is tainted" do
    expect(File.read("/etc/passwd".taint).tainted?).to(be(true))
    expect(File.read("/etc/passwd").tainted?).to(be(false))
  end
end
