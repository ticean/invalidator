# -*- encoding: utf-8 -*-
require File.expand_path('../lib/invalidator/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency('rspec', '~> 2.4')
  s.add_development_dependency('webmock', '~> 1.6')
  s.add_runtime_dependency('aws-sdk', '~> 1.0')
  s.authors = ["Ticean Bennett"]
  s.description = %q{Removes files from S3 and creates CloudFront invalidations}
  s.email = ['ticean@gmail.com']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/ticean/invalidator'
  s.name = 'invalidator'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Remove S3 files with CloudFront invalidations}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Invalidator::VERSION.dup
end
