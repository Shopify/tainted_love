# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tainted_love/version'

Gem::Specification.new do |spec|
  spec.name          = 'tainted_love'
  spec.version       = TaintedLove::VERSION
  spec.authors       = ['Benoit Cote-Jodoin']
  spec.email         = ['benoit.cotejodoin@shopify.com']

  spec.summary       = 'TaintedLove is a dynamic security analysis tool for Ruby'
  spec.homepage      = 'https://github.com/Shopify/tainted_love'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency('bundler', '~> 1.17')
  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_development_dependency('rubocop', '~> 0.65.0')
  spec.add_development_dependency('yard', '~> 0.9.18')
end
