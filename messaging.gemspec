require_relative "lib/messaging/version"

Gem::Specification.new do |spec|
  spec.name        = "messaging"
  spec.version     = Messaging::VERSION
  spec.authors     = ["Hipjea"]
  spec.email       = ["pierre.duverneix@gmail.com"]
  spec.homepage    = "https://github.com/fondation-unit/messaging"
  spec.summary     = "Messaging."
  spec.description = "Description of Messaging."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fondation-unit/messaging"
  spec.metadata["changelog_uri"] = "https://github.com/fondation-unit/messaging/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.2"
end
