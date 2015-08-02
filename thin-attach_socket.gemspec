Gem::Specification.new do |s|
  s.name = "thin-attach_socket"
  s.version = "0.2"
  s.platform = Gem::Platform::RUBY
  s.author = "Conrad Irwin"
  s.email = "conrad.irwin@gmail.com"
  s.homepage = "http://github.com/ConradIrwin/thin-attach_socket"
  s.summary = "Provides Thin::Backends::AttachServer for booting thin on an existing socket."
  s.description = "This is useful for running thin behind einhorn, and requires a recent eventmachine"
  s.files = `git ls-files`.split("\n")
  s.require_path = "lib"
  s.add_dependency 'thin'

  s.requirements << 'eventmachine >= 1.0.4 or eventmachine-le'
end
