RSpec.describe(TaintedLove::Replacer::ReplaceString) do
  it "keeps track of previous tags" do
    tag = { source: "params[:user_input]" }
    user_input = TaintedLove.tag("name".taint, tag)

    message = "Hello " + user_input

    expect(message.tainted_love_tags.first).to(eq(tag))
  end

  it "adds tags only if the source is tainted" do
    user_input = "name"

    TaintedLove.tag(user_input, source: "params[:user_input]")

    message = "Hello " + user_input

    expect(message.tainted_love_tags.first).to(be(nil))
  end

  it "keeps track of previous tags with multiple functions" do
    tag = { source: "params[:user_input]" }
    user_input = TaintedLove.tag("         name   ".taint, tag)

    user_input = user_input * 2
    user_input.strip!

    user_input += " asdf"

    expect(user_input.tainted_love_tags.first).to(eq(tag))
  end


  it "keeps track of split strings" do
    tag = { source: "params[:user_input]" }
    user_input = TaintedLove.tag("name=something".taint, tag)

    key, value = user_input.split('=')

    expect(key.tainted_love_tags.first).to(eq(tag))
    expect(value.tainted_love_tags.first).to(eq(tag))
  end
end
