# -*- encoding: utf-8 -*-
# stub: rspec-power_assert 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-power_assert"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["joker1007"]
  s.date = "2014-11-11"
  s.description = "Power Assert for RSpec.."
  s.email = ["kakyoin.hierophant@gmail.com"]
  s.homepage = "https://github.com/joker1007/rspec-power_assert"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Power Assert for RSpec."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<power_assert>, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<rspec>, [">= 2.14"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<power_assert>, ["~> 0.2.0"])
      s.add_dependency(%q<rspec>, [">= 2.14"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<power_assert>, ["~> 0.2.0"])
    s.add_dependency(%q<rspec>, [">= 2.14"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end
