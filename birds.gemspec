# -*- encoding: utf-8 -*-
# stub: birds 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "birds".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2016-10-12"
  s.description = "Experimental information retrieval system for bibliographic data.".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.extra_rdoc_files = ["README".freeze, "COPYING".freeze, "ChangeLog".freeze]
  s.files = ["COPYING".freeze, "ChangeLog".freeze, "README".freeze, "Rakefile".freeze, "config.ru.sample".freeze, "lib/birds.rb".freeze, "lib/birds/app.rb".freeze, "lib/birds/app/controllers.rb".freeze, "lib/birds/app/helpers.rb".freeze, "lib/birds/app/helpers/controller.rb".freeze, "lib/birds/app/helpers/view.rb".freeze, "lib/birds/app/public/favicon.ico".freeze, "lib/birds/app/settings.rb".freeze, "lib/birds/app/views/_display.erb".freeze, "lib/birds/app/views/_documents.erb".freeze, "lib/birds/app/views/_facets.erb".freeze, "lib/birds/app/views/_spellcheck.erb".freeze, "lib/birds/app/views/browse.erb".freeze, "lib/birds/app/views/document.erb".freeze, "lib/birds/app/views/index.erb".freeze, "lib/birds/app/views/layout.erb".freeze, "lib/birds/app/views/scroll.erb".freeze, "lib/birds/rack_app.rb".freeze, "lib/birds/version.rb".freeze]
  s.homepage = "http://github.com/blackwinter/birds".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\nbirds-0.0.1 [2016-10-12]:\n\n* Initial release.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "birds Application documentation (v0.0.1)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.6".freeze
  s.summary = "Bibliographic information retrieval & document search.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra-bells>.freeze, ["~> 0.4"])
      s.add_runtime_dependency(%q<solr4r>.freeze, ["~> 0.3"])
      s.add_runtime_dependency(%q<unicode>.freeze, ["~> 0.4"])
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.6", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<sinatra-bells>.freeze, ["~> 0.4"])
      s.add_dependency(%q<solr4r>.freeze, ["~> 0.3"])
      s.add_dependency(%q<unicode>.freeze, ["~> 0.4"])
      s.add_dependency(%q<hen>.freeze, [">= 0.8.6", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra-bells>.freeze, ["~> 0.4"])
    s.add_dependency(%q<solr4r>.freeze, ["~> 0.3"])
    s.add_dependency(%q<unicode>.freeze, ["~> 0.4"])
    s.add_dependency(%q<hen>.freeze, [">= 0.8.6", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
