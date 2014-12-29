# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goatmail/version'

Gem::Specification.new do |spec|
  spec.name                  = "goatmail"
  spec.version               = Goatmail::VERSION
  spec.authors               = "Takeshi Yabe"
  spec.email                 = "tyabe@nilidea.com"
  spec.summary               = "Sinatra-based letter_opener web interface"
  spec.description           = 'a Sinatra Application to browse the email sent by letter_opener'
  spec.homepage              = "http://github.com/tyabe/goatmail"
  spec.license               = "MIT"

  spec.files                 = `git ls-files -z`.split("\x0")
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "letter_opener"
  spec.add_dependency "sinatra"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest', "~> 5.3"
  spec.add_development_dependency "minitest-power_assert"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "mail"
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'capybara-webkit'
  spec.add_development_dependency 'capybara_minitest_spec'
  spec.add_development_dependency 'poltergeist'
end
