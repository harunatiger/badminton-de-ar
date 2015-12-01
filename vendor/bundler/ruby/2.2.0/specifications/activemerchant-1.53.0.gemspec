# -*- encoding: utf-8 -*-
# stub: activemerchant 1.53.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activemerchant"
  s.version = "1.53.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tobias Luetke"]
  s.date = "2015-09-01"
  s.description = "Active Merchant is a simple payment abstraction library used in and sponsored by Shopify. It is written by Tobias Luetke, Cody Fauser, and contributors. The aim of the project is to feel natural to Ruby users and to abstract as many parts as possible away from the user to offer a consistent interface across all supported gateways."
  s.email = "tobi@leetsoft.com"
  s.homepage = "http://activemerchant.org/"
  s.licenses = ["MIT"]
  s.rubyforge_project = "activemerchant"
  s.rubygems_version = "2.4.8"
  s.summary = "Framework and tools for dealing with credit card transactions."

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["< 5.0.0", ">= 3.2.14"])
      s.add_runtime_dependency(%q<i18n>, [">= 0.6.9"])
      s.add_runtime_dependency(%q<builder>, ["< 4.0.0", ">= 2.1.2"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, ["~> 3"])
      s.add_development_dependency(%q<mocha>, ["~> 1"])
      s.add_development_dependency(%q<thor>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, ["< 5.0.0", ">= 3.2.14"])
      s.add_dependency(%q<i18n>, [">= 0.6.9"])
      s.add_dependency(%q<builder>, ["< 4.0.0", ">= 2.1.2"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<test-unit>, ["~> 3"])
      s.add_dependency(%q<mocha>, ["~> 1"])
      s.add_dependency(%q<thor>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["< 5.0.0", ">= 3.2.14"])
    s.add_dependency(%q<i18n>, [">= 0.6.9"])
    s.add_dependency(%q<builder>, ["< 4.0.0", ">= 2.1.2"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<test-unit>, ["~> 3"])
    s.add_dependency(%q<mocha>, ["~> 1"])
    s.add_dependency(%q<thor>, [">= 0"])
  end
end
