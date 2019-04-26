![License](https://img.shields.io/github/license/shopify/tainted_love.svg)
![Version](https://img.shields.io/gem/v/tainted_love.svg)


# TaintedLove

TaintedLove is a dynamic security analysis tool for Ruby. It leverages Ruby's object tainting and monkey patching features to identify vulnerable code paths at runtime.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tainted_love'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tainted_love


## Usage

TaintedLove needs to replace multiple functions. It is ideal to enable it when the application has all of its dependencies loaded and is ready to use.

To enable TaintedLove in your project:

```ruby
TaintedLove.enable! do |config|
  # This is the default configuration
  # config.logger = Logger.new
  # config.replacers = TaintedLove::Replacer::Base.replacers
  # config.validators = TaintedLove::Validator::Base.validators
  # config.reporter = TaintedLove::Reporter::StdoutReporter.new
end
```

In Ruby on Rails, this could be done in an initializer file `config/initializer/tainted_love.rb`

```ruby
TaintedLove.enable! do |config|
  config.logger = Rails.logger
end
```

Start your application! The default reporter will output into the console.

## Detected Patterns
TaintedLove currently detects the following patterns. If the execution of the application ever encounters these function calls, TaintedLove will report it.

```ruby
Object#send(tainted_input_1, tainted_input_2)
File.read(tainted_input).taint
File.write(tainted_input, _)
Kernel#eval(tainted_input)
Kernel#system(tainted_input)
Kernel#`(tainted_input)
Kernel#open("|" + tainted_input)
Marshal.load(tainted_input)
YAML.load(tainted_input)

# Rails specific patterns
render(tainted_input)
render(inline: tainted_input)
render(file: tainted_input)
<%= tainted_input.html_safe %>
Model.where(tainted_input)
Model.select(tainted_input)
Model.find_by_sql(tainted_input)
Model.count_by_sql(tainted_input)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/tainted_love.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
