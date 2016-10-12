require_relative 'lib/birds/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{birds},
      version:      Birds::VERSION,
      summary:      %q{Bibliographic information retrieval & document search.},
      description:  %q{Experimental information retrieval system for bibliographic data.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      extra_files:  FileList['*.sample', 'lib/**/{public{,/{css,images,js}},views}/*'].to_a,
      dependencies: {
        'sinatra-bells' => '~> 0.4',
        'solr4r'        => '~> 0.3',
        'unicode'       => '~> 0.4'
      },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

desc 'Run IRB console'
task console: :load do
  require 'irb'; IRB.start
end

desc 'Run rackup command'
task rackup: :load do
  load Gem.bin_path('rack', 'rackup')
end

task :load do
  ARGV.clear

  b = ENV['DEVEL'] and %w[sinatra-bells solr4r].each { |i|
    $:.unshift(File.join(File.expand_path(b), i, 'lib')) }

  $:.unshift('lib')

  require 'birds'
  require 'birds/app'
end
