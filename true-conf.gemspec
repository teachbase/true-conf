# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "true-conf/version"

Gem::Specification.new do |spec|
  spec.name = "true-conf"
  spec.version = TrueConf::VERSION
  spec.authors = "Andrey Paderin"
  spec.email = "andy.paderin@gmail.com"

  spec.summary = "TrueConf Server API client"
  spec.homepage = "https://github.com/paderinandrey/true-conf"
  spec.license = "MIT"

  spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE.txt]
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "evil-client", "~> 3.0"
  spec.add_runtime_dependency "oauth2", "~> 1.4"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rubocop", ">= 0.92.0"
  spec.add_development_dependency "simplecov", ">= 0.19"
  spec.add_development_dependency "webmock", "~> 3.5"
end
