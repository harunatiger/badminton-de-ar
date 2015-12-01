# -*- encoding: utf-8 -*-
# stub: pry-coolline 0.2.5 ruby lib

Gem::Specification.new do |s|
  s.name = "pry-coolline"
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["John Mair (banisterfiend)"]
  s.date = "2014-09-14"
  s.description = "Live syntax-highlighting for the Pry REPL"
  s.email = "jrmair@gmail.com"
  s.homepage = "https://github.com/pry/pry-coolline"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.4.8"
  s.summary = "Live syntax-highlighting for the Pry REPL"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<coolline>, ["~> 0.5"])
      s.add_development_dependency(%q<riot>, [">= 0"])
    else
      s.add_dependency(%q<coolline>, ["~> 0.5"])
      s.add_dependency(%q<riot>, [">= 0"])
    end
  else
    s.add_dependency(%q<coolline>, ["~> 0.5"])
    s.add_dependency(%q<riot>, [">= 0"])
  end
end
