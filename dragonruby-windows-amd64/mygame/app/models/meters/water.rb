module Meters
  class Water < Meter
    death_message "Your body is 62% water, and you didn't give it any.".freeze
    rate 0.001
    state_prop :water

    def initialize(args:, row:, col:)
      self.args = args
      self.row = row
      self.col = col
    end

    def color
      {
        r: 78 * state[state_prop],
        g: 175 * state[state_prop],
        b: 215 * state[state_prop]
      }
    end
  end
end
