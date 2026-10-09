require_relative "lib/spina/pro/version"

Gem::Specification.new do |spec|
  spec.name        = "spina-pro"
  spec.version     = Spina::Pro::VERSION
  spec.authors     = ["Bram Jetten"]
  spec.email       = ["mail@bramjetten.nl"]
  spec.homepage    = "https://www.spinacms.com"
  spec.summary     = "Spina Pro"
  spec.description = "Level up your Spina CMS project"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md", "LICENSE", "CHANGELOG.md"]

  spec.add_dependency "spina", ">= 2.21", "< 3"
  spec.add_dependency "pg_search"
  # spec.add_dependency "acts_as_tenant", ">= 0.5.1"
end
