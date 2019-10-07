$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "hstore_flags/version"

Gem::Specification.new do |s|
  s.name          = "hstore_flags"
  s.version       = HStoreFlags::VERSION
  s.summary       = "Store many boolean flags in an hstore column in PostgreSQL"
  s.description   = "turns an hstore column into a very useful flags container " +
                    "instead of using separate columns"
  s.authors       = ["Zachery Hostens"]
  s.email         = "zacheryph@gmail.com"
  s.homepage      = "https://github.com/zacheryph/hstore_flags"
  s.files         = `git ls-files`.split("\n")
  s.license       = "MIT"
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "~> 4.0"

  s.add_development_dependency "rspec", "~> 2.14"
  s.add_development_dependency "pg", "~> 0.17"
end
