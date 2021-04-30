module Meters
  class Pee < Meters::Inverse
    death_message "Eeeeew...".freeze
    rate -0.0001
    state_prop :pee

    def initialize(args:, row:, col:)
      self.args = args
      self.row = row
      self.col = col
    end

    # 255, 204, 52
    # 205, 154, 0
    def color
      {
        r: 255 - (50 * state[state_prop]),
        g: 204 - (50 * state[state_prop]),
        b: 52 * debuff
      }
    end
  end
end
