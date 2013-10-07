# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "animate-rails"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Masahiro Saito"]
  s.date = "2013-07-21"
  s.description = "animate.css for rails"
  s.email = ["camelmasa@gmail.com"]
  s.homepage = "https://github.com/camelmasa/animate-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "animate.css for rails"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 0"])
  end
end
