# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
gem "standard", "~> 0.6.0", require: false

# Specify your gem's dependencies in true-conf.gemspec
gemspec
group :development, :test do
  gem 'pry', '~> 0.14.2', platform: :mri
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1', platform: :mri
end
