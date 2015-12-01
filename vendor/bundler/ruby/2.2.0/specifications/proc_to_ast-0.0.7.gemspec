# -*- encoding: utf-8 -*-
# stub: proc_to_ast 0.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "proc_to_ast"
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["joker1007"]
  s.date = "2014-09-01"
  s.description = "Add #to_ast method to Proc. #to_ast converts Proc object to AST::Node."
  s.email = ["kakyoin.hierophant@gmail.com"]
  s.homepage = "https://github.com/joker1007/proc_to_ast"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.4.8"
  s.summary = "Convert Proc object to AST::Node"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<parser>, [">= 0"])
      s.add_runtime_dependency(%q<unparser>, [">= 0"])
      s.add_runtime_dependency(%q<coderay>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 1.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<parser>, [">= 0"])
      s.add_dependency(%q<unparser>, [">= 0"])
      s.add_dependency(%q<coderay>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 1.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<parser>, [">= 0"])
    s.add_dependency(%q<unparser>, [">= 0"])
    s.add_dependency(%q<coderay>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 1.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
