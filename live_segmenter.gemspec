
Gem::Specification.new do |s|
  s.name        = "live_segmenter"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carson McDonald", "Ola Bini"]
  s.email       = ["ola.bini@gmail.com"]
  s.homepage    = "https://github.com/carsonmcdonald/HTTP-Live-Video-Stream-Segmenter-and-Distributor"
  s.summary     = %q{???}
  s.description = s.summary

  s.extra_rdoc_files = ['README.md']
  s.rdoc_options << '--title' << 'xample' << '--main' << 'README' << '--line-numbers'

  s.files         = Dir['{lib,test}/**/*.rb', '[A-Z]*$', 'extconf.rb', 'example-configs/**/*', 'bin/*', '*.c', 'extconf.rb'].to_a
  s.require_paths = ["lib"]
  s.bindir        = 'bin'
  s.extensions    << 'extconf.rb'
  s.executables   << 'http_streamer'
end
