# frozen_string_literal: true

require_relative "lib/omniauth/dropbox_business/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth_dropbox_business"
  spec.version = OmniAuth::DropboxBusiness::VERSION
  spec.authors = ["FirmStudio API Engineering team"]
  spec.email = ["api-engineering@firmstudio.io"]

  spec.summary = "OmniAuth strategy for Dropbox Business"
  spec.description = "OmniAuth strategy for Dropbox Business"
  spec.homepage = "https://github.com/firmstudio/omniauth-dropbox-business"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/).reject { |f| f.match(%r{^(\.gem)$}) }
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "omniauth", "~> 2.0"
  spec.add_dependency "omniauth-oauth2", "~> 1.8.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
