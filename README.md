# TaintedLove
TaintedLove is a dynamic taint reporting tool for Ruby allowing to track user input into unsafe functions.

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
TaintedLove is enabled in your project

```ruby
TaintedLove.enable! do |config|
  # [...]
end
```

In Ruby on Rails, this could be in an initializer

```ruby
TaintedLove.enable! do |config|
  config.logger = Rails.logger
end
```

Start your application! The default reporter will output into the console. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Shopify/tainted_love.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
