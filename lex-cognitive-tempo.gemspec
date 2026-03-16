# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_tempo/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-tempo'
  spec.version       = Legion::Extensions::CognitiveTempo::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Cognitive Tempo'
  spec.description   = 'Cognitive processing speed and rhythm modeling for brain-modeled agentic AI'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-tempo'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']        = spec.homepage
  spec.metadata['source_code_uri']     = 'https://github.com/LegionIO/lex-cognitive-tempo'
  spec.metadata['documentation_uri']   = 'https://github.com/LegionIO/lex-cognitive-tempo'
  spec.metadata['changelog_uri']       = 'https://github.com/LegionIO/lex-cognitive-tempo'
  spec.metadata['bug_tracker_uri']     = 'https://github.com/LegionIO/lex-cognitive-tempo/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-cognitive-tempo.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
