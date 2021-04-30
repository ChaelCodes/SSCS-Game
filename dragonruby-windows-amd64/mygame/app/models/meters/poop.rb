module Meters
  class Poop < Meters::Inverse
    death_message "You've died of dysentary.".freeze
    rate 0.0
    state_prop :poop

    def initialize(args:, row:, col:)
      self.args = args
      self.row = row
      self.col = col
    end

    def color
      {
        r: 72,
        g: 38,
        b: 13
      }
    end
  end
end
