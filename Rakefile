require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the relata plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the relata plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Relata'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

PKG_FILES = FileList[ '[a-zA-Z]*', 'generators/**/*', 'lib/**/*', 'rails/**/*', 'tasks/**/*', 'test/**/*' ] 

spec = Gem::Specification.new do |s|
   s.name = "Relata"  
   s.version = "0.0.2"  
   s.author = "Anderson Leite, Guilherme Silveira"  
   s.email = "anderson.leite@caelum.com.br"  
   s.homepage = "http://github.com/caelum/relata"  
   s.platform = Gem::Platform::RUBY 
   s.summary = "Helps poking around with relationships when using ARel"
   s.files = PKG_FILES.to_a 
   s.require_path = "lib"  
   s.has_rdoc = false 
   s.extra_rdoc_files = ["README.markdown"] 
end 

desc 'Turn this plugin into a gem.' 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.gem_spec = spec 
end