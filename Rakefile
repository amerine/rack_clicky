require 'rake/clean'
require 'rake/testtask'
require 'fileutils'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

###### Packaging

def package_version
  @package_version ||= begin
    unless defined? RackClicky::Version
      load './lib/rack_clicky/version.rb'
    end
    RackClicky::VERSION
  end
end

if defined? Gem
  def spec
    require 'rubygems' unless defined? Gem::Specification
    @spec || eval(File.read('rack_clicky.gemspec'))
  end

  def package(ext = '')
    "pkg/rack_clicky-#{spec.version}" + ext
  end

  desc "Build rack_clicky packages"
  task :package => %w[.gem .tar.gz].map {|e| package(e)}

  desc "Install rack_clicky locally"
  task :install => package('.gem') do
    sh "gem install #{package('.gem')}"
  end

  directory "pkg/"
  CLOBBER.include "pkg/"

  file package(".gem") => %w[pkg/ rack_clicky.gemspec] + spec.files do |f|
    sh "gem build rack_clicky.gemspec"
    mv File.basename(f.name), f.name
  end

  file package(".tar.gz") => %w[pkg/] + spec.files do |f|
    sh <<-SH
      git archive \
      --prefix=rack_clicky-#{package_version}/ \
      --format=tar \
      HEAD | gzip > #{f.name}
    SH
  end

  desc "Release rack_clicky"
  task :release => ['test', package(".gem")] do
    sh <<-SH
      gem push #{package(".gem")} &&
      git commit --allow-empty -a -m '#{package_version} release'  &&
      git tag v#{package_version} -m '#{package_version} release'  &&
      git push &&
      git push --tags
    SH
  end
end
