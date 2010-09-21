require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the filtered_relation plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the filtered_relation plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'FilteredRelation'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# filtered_relation gem 

PKG_FILES = FileList[ '[a-zA-Z]*', 'generators/**/*', 'lib/**/*', 'rails/**/*', 'tasks/**/*', 'test/**/*' ] 

spec = Gem::Specification.new do |s|
   s.name = "filtered_relation"  
   s.version = "0.0.1"  
   s.author = "Anderson Leite"  
   s.email = "andersonlfl@gmail.com"  
   s.homepage = "http://github.com/andersonleite/filtered_relation"  
   s.platform = Gem::Platform::RUBY 
   s.summary = "Making dynamic filters easier"  
   s.files = PKG_FILES.to_a 
   s.require_path = "lib"  
   s.has_rdoc = false 
   s.extra_rdoc_files = ["README"] 
end 

desc 'Turn this plugin into a gem.' 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.gem_spec = spec 
end 