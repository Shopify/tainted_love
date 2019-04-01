RSpec.describe(TaintedLove::Replacer::ReplaceFile) do
  it "taints the output only if the input is tainted" do
    expect(File.read("/etc/passwd".taint).tainted?).to(be(true))
    expect(File.read("/etc/passwd").tainted?).to(be(false))
  end

  it "reports if writing using a tainted file name" do
    expect(TaintedLove).to(receive(:report).once)

    File.write("/tmp/test", "")
    File.write("/tmp/test".taint, "")
  end
end
