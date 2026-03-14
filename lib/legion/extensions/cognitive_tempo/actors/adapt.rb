# frozen_string_literal: true

require 'legion/extensions/actors/every'

module Legion
  module Extensions
    module CognitiveTempo
      module Actor
        class Adapt < Legion::Extensions::Actors::Every
          def runner_class
            Legion::Extensions::CognitiveTempo::Runners::Tempo
          end

          def runner_function
            'tempo_report'
          end

          def time
            60
          end

          def run_now?
            false
          end

          def use_runner?
            false
          end

          def check_subtask?
            false
          end

          def generate_task?
            false
          end
        end
      end
    end
  end
end
