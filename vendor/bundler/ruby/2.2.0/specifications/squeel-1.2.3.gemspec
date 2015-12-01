# -*- encoding: utf-8 -*-
# stub: squeel 1.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "squeel"
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ernie Miller", "Xiang Li"]
  s.date = "2015-02-05"
  s.description = "\n      Squeel unlocks the power of Arel in your Rails application with\n      a handy block-based syntax. You can write subqueries, access named\n      functions provided by your RDBMS, and more, all without writing\n      SQL strings. Supporting Rails 3 and 4.\n    "
  s.email = ["ernie@erniemiller.org", "bigxiang@gmail.com"]
  s.homepage = "https://github.com/ernie/squeel"
  s.rubyforge_project = "squeel"
  s.rubygems_version = "2.4.8"
  s.summary = "Active Record, improved."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<polyamorous>, ["~> 1.1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<faker>, ["~> 0.9.5"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_development_dependency(%q<mysql>, ["~> 2.9.1"])
      s.add_development_dependency(%q<mysql2>, ["~> 0.3.16"])
      s.add_development_dependency(%q<pg>, ["~> 0.17.1"])
      s.add_development_dependency(%q<git_pretty_accept>, ["~> 0.4.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<polyamorous>, ["~> 1.1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<faker>, ["~> 0.9.5"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_dependency(%q<mysql>, ["~> 2.9.1"])
      s.add_dependency(%q<mysql2>, ["~> 0.3.16"])
      s.add_dependency(%q<pg>, ["~> 0.17.1"])
      s.add_dependency(%q<git_pretty_accept>, ["~> 0.4.0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<polyamorous>, ["~> 1.1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<faker>, ["~> 0.9.5"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
    s.add_dependency(%q<mysql>, ["~> 2.9.1"])
    s.add_dependency(%q<mysql2>, ["~> 0.3.16"])
    s.add_dependency(%q<pg>, ["~> 0.17.1"])
    s.add_dependency(%q<git_pretty_accept>, ["~> 0.4.0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
