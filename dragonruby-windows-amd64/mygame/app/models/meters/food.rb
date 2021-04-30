module Meters
  class Food < Meter
    death_message "Why did you starve yourself?".freeze
    rate 0.0005
    state_prop :food

    def initialize(args:, row:, col:)
      self.args = args
      self.row = row
      self.col = col
    end

    # Can we have this change color as it drops?
    def color
      {
        r: 100 * state[state_prop],
        g: 180 * state[state_prop],
        b: 100 * state[state_prop]
      }
    end
  end
end
