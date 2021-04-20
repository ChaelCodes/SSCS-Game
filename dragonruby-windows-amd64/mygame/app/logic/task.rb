class Task
  attr_gtk
  attr :args

  def initialize(args)
    self.args = args
  end

  def defaults
    args.state.task_progress ||= 0
  end

  def render
    full_meter = args.layout.rect(row: 4, col: 6.4, w: 10, h: 1).merge({red: 255, green: 255, blue: 255}).solid
    full_meter[:w] = full_meter[:w] * args.state.task_progress
    [
      [600, 500, "|rate: #{args.state.task_rate.to_sf}, progress: #{args.state.task_progress.to_sf} |", 5, 1].label,
      full_meter,
      args.layout.rect(row: 4, col: 6.4, w: 10, h: 1).border
    ]
  end

  def calc
    args.state.task_progress += (args.state.task_rate * 0.001)
    reset_progress if state.store
    if args.state.task_progress >= 1
      args.state.money += 50
      args.state.task_progress -= 1
    end
  end

  def reset
    args.state.money = 0
    args.state.task_progress = 0
  end

  def reset_progress
    args.state.task_progress = 0
  end
end

$gtk.reset
$game = nil
