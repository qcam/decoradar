# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'decoradar/version'

Gem::Specification.new do |spec|
  spec.name          = "decoradar"
  spec.version       = Decoradar::VERSION
  spec.authors       = ["Cẩm Huỳnh"]
  spec.email         = ["huynhquancam@gmail.com"]

  spec.summary       = %q{Simple decorator + serializer}
  spec.description   = %q{Simple decorator + serializer in Ruby}
  spec.homepage      = "https://github.com/huynhquancam/decoradar"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
