RSpec.describe TaintedLove::Replacer::ReplaceMarshal do
  it "replaces Marshal.load" do
    expect(TaintedLove).to receive(:report).once

    Marshal.load("\x04\bI\"\x00\x06:\x06ET".taint)
    Marshal.load("\x04\bI\"\x00\x06:\x06ET")
  end
end
