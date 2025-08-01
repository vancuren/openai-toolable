# frozen_string_literal: true

require_relative "lib/openai/toolable/version"

Gem::Specification.new do |spec|
  spec.name = "openai-toolable"
  spec.version = Openai::Toolable::VERSION
  spec.authors = ["Russell Van Curen"]
  spec.email = ["russell@vancuren.net"]

  spec.summary = "A Ruby gem that extends the OpenAI SDK to support function calling."
  spec.description = "This gem provides a simple and flexible way to define and use tools with the OpenAI API."
  spec.homepage = "https://github.com/vancuren/openai-toolable"
  spec.required_ruby_version = ">= 3.2.0"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/vancuren/openai-toolable"
  spec.metadata["changelog_uri"] = "https://github.com/vancuren/openai-toolable/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor|Gemfile.lock)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "openai", "~> 0.16.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
