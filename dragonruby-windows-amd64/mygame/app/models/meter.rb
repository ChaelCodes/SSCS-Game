class Meter
  attr_gtk
  attr :row, :col

  def self.death_message value
    define_method :death_message do
      value.freeze
    end
  end

  def self.rate value
    define_method :rate do
      value
    end
  end

  def self.state_prop value
    define_method :state_prop do
      value
    end
  end

  def initialize(args:, row:, col:)
    self.args = args
    self.row = row
    self.col = col
  end

  def defaults
    state[state_prop] ||= 1.0
  end

  def render
    full_meter = args.layout.rect(row: row, col: col, w: 1, h: 10).merge(color).solid
    full_meter[:h] = full_meter[:h] * args.state[state_prop]
    [
      full_meter,
      args.layout.rect(row: row, col: col, w: 1, h: 10).border
    ]
  end

  def calc
    args.state[state_prop] -= rate
    args.state.task_rate *= debuff
    args.state[state_prop] = args.state[state_prop].clamp(0, 1.0)
    die(death_message) if dead?
  end

  def debuff
    args.state[state_prop]
  end

  # Death Functions
  def player_alive?
    state.death_message.empty?
  end

  def dead?
    args.state[state_prop].zero?
  end

  def die(message)
    return if player_alive?
    state.death_message = message
    state.time_of_death = state.tick_count
    state.death = true
    state.next_scene = :death
  end

  def reset
    args.state[state_prop] = nil
    defaults
  end
end

$gtk.reset
$game = nil
