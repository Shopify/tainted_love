RSpec.describe(TaintedLove::Replacer::ReplaceYAML) do
  it "reports usage of YAML.load using tainted input" do
    expect(TaintedLove).to(receive(:report).once)

    YAML.load('2')
    YAML.load('2'.taint)
  end
end
