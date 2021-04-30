module Meters
  class Inverse < Meter
    def defaults
      state[state_prop] ||= 0.0
    end

    def debuff
      1 - args.state[state_prop]
    end

    def dead?
      args.state[state_prop] == 1
    end
  end
end
