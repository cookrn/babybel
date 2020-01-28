require_relative 'lib/babybel/version'

Gem::Specification.new do |spec|
  spec.name          = "babybel"
  spec.version       = Babybel::VERSION
  spec.authors       = ["Ryan Cook"]
  spec.email         = ["cookrn@gmail.com"]

  spec.summary       = %q{Babybel is a Bel lisp implementation.}
  spec.description   = %q{Babybel is a Bel lisp implementation.}
  spec.homepage      = "https://github.com/cookrn/babybel"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/tree/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "parslet", "~> 1.8"
end
