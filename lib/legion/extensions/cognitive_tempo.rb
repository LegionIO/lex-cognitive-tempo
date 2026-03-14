# frozen_string_literal: true

require 'legion/extensions/cognitive_tempo/version'
require 'legion/extensions/cognitive_tempo/helpers/constants'
require 'legion/extensions/cognitive_tempo/helpers/tempo_record'
require 'legion/extensions/cognitive_tempo/helpers/tempo_engine'
require 'legion/extensions/cognitive_tempo/runners/tempo'

module Legion
  module Extensions
    module CognitiveTempo
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
