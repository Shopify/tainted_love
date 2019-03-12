# frozen_string_literal: true

RSpec.describe(TaintedLove::Replacer::ReplaceKernel) do
  it "replaces eval" do
    expect(TaintedLove).to(receive(:report).once)

    eval("1 + 2")
    eval("1 + 2".taint)
  end

  it "replaces system" do
    expect(TaintedLove).to(receive(:report).once)

    system("1 + 2")
    system("1 + 2".taint)
  end

  it "replaces `" do
    cmd = "cat /dev/null"

    expect(TaintedLove).to(receive(:report).once)

    %x(#{cmd})
    %x(#{cmd.taint})
  end
end
