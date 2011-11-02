# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "perfect_price/version"

Gem::Specification.new do |s|
  s.name        = "perfect_price"
  s.version     = PerfectPrice::VERSION
  s.authors     = ["Aleksey Gureiev"]
  s.email       = ["spyromus@noizeramp.com"]
  s.homepage    = ""
  s.summary     = %q{Plans and pricing made easy}
  s.description = %q{Configure your plans easily and then use them to calculate totals}

  s.rubyforge_project = "perfect_price"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  
  s.add_runtime_dependency "hashie"
  s.add_runtime_dependency "json"
end
