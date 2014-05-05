# -*- encoding: utf-8 -*-
# stub: progressive_io 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "progressive_io"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Julik Tarkhanov"]
  s.date = "2011-08-04"
  s.description = "A wrapper for IO objects that allows a callback to be set which is called when an object is read from"
  s.email = ["me@ujulik.nl"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.homepage = "http://github.com/julik/progressive_io"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "progressive_io"
  s.rubygems_version = "2.1.11"
  s.summary = "A wrapper for IO objects that allows a callback to be set which is called when an object is read from"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<flexmock>, ["~> 0.8"])
      s.add_development_dependency(%q<hoe>, ["~> 2.10"])
    else
      s.add_dependency(%q<flexmock>, ["~> 0.8"])
      s.add_dependency(%q<hoe>, ["~> 2.10"])
    end
  else
    s.add_dependency(%q<flexmock>, ["~> 0.8"])
    s.add_dependency(%q<hoe>, ["~> 2.10"])
  end
end
