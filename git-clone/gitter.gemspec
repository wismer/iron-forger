lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "gitter"
  spec.version = '0.0.1'
  spec.authors = ["wismer"] 
  spec.email   = ["matthewhl@gmail.com"]
  spec.description = "iron-forger for hacker school"
  spec.homepage = "http://wismer.github.io"
  spec.license = "MIT"
  spec.files = Dir["lib/**/*"]
  spec.executables << 'gitter'
  spec.require_paths = ["lib"]
  spec.summary = 'iron forger week 3 - make a CLI git clone'
end
