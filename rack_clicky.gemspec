# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack_clicky/version"

Gem::Specification.new do |s|
  s.name        = "rack_clicky"
  s.version     = RackClicky::VERSION
  s.authors     = ["Mark Turner"]
  s.email       = ["mark@amerine.net"]
  s.homepage    = "http://github.com/amerine/rack_clicky"
  s.summary     = %q{Clicky Analytics for your Rack Apps}
  s.description = %q{Embeds the Clicky tracking code at the end of your HTML}

  s.rubyforge_project = "rack_clicky"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "minitest"

  s.add_dependency "rack"
end
