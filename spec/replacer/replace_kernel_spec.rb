RSpec.describe(TaintedLove::Replacer::ReplaceKernel) do
  it "reports usage of eval using a tainted input" do
    expect(TaintedLove).to(receive(:report).once)

    eval("1 + 2")
    eval("1 + 2".taint)
  end

  it "reports usage of system using a tainted input" do
    expect(TaintedLove).to(receive(:report).once)

    system("1 + 2")
    system("1 + 2".taint)
  end

  it "reports usage of ` using a tainted input" do
    cmd = "cat /dev/null"

    expect(TaintedLove).to(receive(:report).once)

    %x(#{cmd})
    %x(#{cmd.taint})
  end

  it "reports if open is used for command execution using a tainted input" do
    expect(TaintedLove).to(receive(:report).once)

    open('|id')
    open('|id'.taint)
  end

  it "makes open return a tainted string only if the input is tainted" do
    expect(open('/dev/null').tainted?).to(be(false))
    expect(open('/dev/null'.taint).tainted?).to(be(true))
  end
end
