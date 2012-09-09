# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git_dj/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mikhail Tabunov"]
  gem.email         = ["mikhail@tabunov.ru"]
  gem.description   = %q{A simple and lightweight alternative to git flow}
  gem.summary       = %q{Git dj<D-d>}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "git_dj"
  gem.require_paths = ["lib"]
  gem.version       = GitDj::VERSION
end
