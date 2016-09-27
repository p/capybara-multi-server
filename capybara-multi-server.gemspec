# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "capybara-multi-server"
  spec.version       = '0.1.0'
  spec.authors       = ["Oleg Pudeyev"]
  spec.email         = ["oleg@bsdpower.com"]

  spec.summary       = %q{Multiple server launcher for Capybara}
  spec.description   = %q{Launch a frontend server when running Capybara tests.}
  spec.homepage      = "https://github.com/p/capybara-multi-server"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency 'capybara'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
