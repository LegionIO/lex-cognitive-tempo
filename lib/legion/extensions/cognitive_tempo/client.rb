# frozen_string_literal: true

require 'legion/extensions/cognitive_tempo/helpers/constants'
require 'legion/extensions/cognitive_tempo/helpers/tempo_record'
require 'legion/extensions/cognitive_tempo/helpers/tempo_engine'
require 'legion/extensions/cognitive_tempo/runners/tempo'

module Legion
  module Extensions
    module CognitiveTempo
      class Client
        include Runners::Tempo

        def initialize(**)
          @tempo_engine = Helpers::TempoEngine.new
        end

        private

        attr_reader :tempo_engine
      end
    end
  end
end
