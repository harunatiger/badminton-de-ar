# -*- encoding: utf-8 -*-
# stub: rspec-parameterized 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-parameterized"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["tomykaira"]
  s.date = "2015-02-13"
  s.description = "RSpec::Parameterized supports simple parameterized test syntax in rspec."
  s.email = ["tomykaira@gmail.com"]
  s.homepage = ""
  s.rubygems_version = "2.4.8"
  s.summary = "RSpec::Parameterized supports simple parameterized test syntax in rspec. I was inspired by [udzura's mock](https://gist.github.com/1881139)."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, ["< 4", ">= 2.13"])
      s.add_runtime_dependency(%q<parser>, [">= 0"])
      s.add_runtime_dependency(%q<unparser>, [">= 0"])
      s.add_runtime_dependency(%q<proc_to_ast>, [">= 0"])
      s.add_runtime_dependency(%q<binding_of_caller>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["< 4", ">= 2.13"])
      s.add_dependency(%q<parser>, [">= 0"])
      s.add_dependency(%q<unparser>, [">= 0"])
      s.add_dependency(%q<proc_to_ast>, [">= 0"])
      s.add_dependency(%q<binding_of_caller>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["< 4", ">= 2.13"])
    s.add_dependency(%q<parser>, [">= 0"])
    s.add_dependency(%q<unparser>, [">= 0"])
    s.add_dependency(%q<proc_to_ast>, [">= 0"])
    s.add_dependency(%q<binding_of_caller>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
