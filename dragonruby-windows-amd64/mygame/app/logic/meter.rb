class Meter
  attr_gtk
  attr :row, :col, :color, :death_message, :rate, :state_prop

  def initialize(args:, row:, col:, color:, death_message: 'You died.', rate: 0.001, state_prop:)
    self.args = args
    self.row = row
    self.col = col
    self.color = color
    self.death_message = death_message
    self.rate = rate
    self.state_prop = state_prop
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
  end

  def debuff
    args.state[state_prop]
  end

  def dead?
    args.state[state_prop].zero?
  end

  def reset
    args.state[state_prop] = nil
    defaults
  end
end

$gtk.reset
$game = nil
