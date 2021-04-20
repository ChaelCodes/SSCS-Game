require 'app/logic/meter.rb'
require 'app/logic/store.rb'
require 'app/logic/task.rb'

class Game
  attr_gtk
  attr :meters

  def initialize(args)
    self.args = args
    @water_bottle = { x: 1050, y: 105, w: 100, h: 266, path: 'sprites/bottle-small.png'}
    @granola_bar = { x: 20, y: 80, w: 226, h: 101, angle: 317, path: 'sprites/granola-small.png'}
    @store = Store.new(args: args)
    @store_icon = { x: 575, y: 340, w: 50, h: 50, path: 'sprites/cart.png'}
    init_meters
    @task = Task.new(args)
  end

  def tick
    defaults
    render
    input
    calc
  end

  def defaults
    state.scene ||= :game
    state.store ||= false
    state.granola_count ||= 10
    state.money ||= 0
    @task.defaults
    meters.each(&:defaults)
  end

  # Render Order
  # Solids
  # Sprites
  # Primitives
  # Labels
  # Lines
  # Borders
  # Debug
  def render
    case state.scene
      when :death
        death_scene
      when :pause
        pause_scene
      else
        game_scene
    end
    
    if state.store && state.scene == :game
      @store.laptop_store_scene
    end
  end

  def input
    if args.inputs.mouse.click
      if state.death
        reset if state.time_of_death.elapsed_time > 60
      end
      if args.inputs.mouse.click.intersect_rect? @water_bottle
        state.water += 0.1
        # args.outputs.sounds << 'sounds/water.wav'
      end
      if args.inputs.mouse.click.intersect_rect? @granola_bar
        if state.granola_count > 0
          state.food += 0.1
          state.granola_count -= 1
        end
      end
      if args.inputs.mouse.click.intersect_rect? @store_icon
        @store.open
      end
    end
    if args.inputs.keyboard.key_down.w
      state.water += 0.1
    end
    if args.inputs.keyboard.key_down.f
      if state.granola_count > 0
        state.food += 0.1
        state.granola_count -= 1
      end
    end
    # Open/Close the store
    if args.inputs.keyboard.key_down.s
      state.store ? @store.close : @store.open
    end
    if state.store
      @store.input
    end
    if inputs.keyboard.key_down.p
      state.scene = state.scene == :pause ? :game : :pause
    end
    # save
    if args.inputs.keyboard.key_down.t
      $gtk.save_state
    end
    # load
    if args.inputs.keyboard.key_down.r
      $gtk.load_state
    end
  end

  def calc
    return if [:death, :pause].include?(state.scene)
    state.task_rate = 1.0
    meters.each do |meter|
      meter.calc
      return die(meter.death_message) if meter.empty?
    end
    @task.calc
  end

  def die(message)
    state.death_message = message
    state.time_of_death = state.tick_count
    state.death = true
    state.scene = :death
  end

  # Scenes
  def death_scene
    outputs.primitives << [
      { w: 1280, h: 720, r: 0, g: 0, b: 0}.solid,
      { x: 640, y: 460, text: 'You have died.', r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label,
      { x: 640, y: 400, text: state.death_message, r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label,
      { x: 640, y: 340, text: "You made $#{state.money}, and survived #{state.time_of_death.fdiv(3600).to_sf} minutes.", r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label
    ]
  end

  def game_scene
    outputs.labels  << [600, 620, 'Sadistic Self-Care Survival Game!', 5, 1]
    outputs.primitives << meters.map(&:render)
    outputs.primitives << [
      @task.render,
      { x: 340, y: 370, text: "Money: $#{state.money}", size_enum: 5, alignment_enum: align(:left) }.label,
      { x: 80, y: 90, text: state.granola_count }.label
    ]
    outputs.debug << [30, 30.from_top, "#{args.inputs.mouse.point}"].label
    # Sprites
    outputs.sprites << [
      [0, 0, 1280, 720, 'sprites/laptop.png'],
      @water_bottle,
      @granola_bar,
      @store_icon
    ]
  end

  def init_meters
    self.meters = [
      Meter.new(args: args, row: 0, col: 0, color: {r: 100, g: 180, b: 100}, death_message: 'Why did you starve yourself?', rate: 0.0005, state_prop: :food),
      Meter.new(args: args, row: 0, col:23, color: {r: 78, g: 175, b: 215}, death_message: "Your body is 62% water, and you didn't give it any.", rate: 0.001, state_prop: :water)
    ]
  end

  def pause_scene
    outputs.primitives << [
      { w: 1280, h: 720, r: 0, g: 0, b: 0}.solid,
      { x: 640, y: 460, text: "Pausing? There is no pause on life. Your body doesn't take a break.", r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label
    ]
  end

  def reset
    Kernel.tick_count = 0
    state.death = false
    state.scene = :game      
    state.death_message = nil
    state.money = 0
    state.granola_count = 10
    @store.reset
    meters.each(&:reset)
    @task.reset
  end
end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick
end

def align(alignment)
  case alignment
  when :center
    1
  when :left
    0
  when :right
    2
  end
end

$gtk.reset
$game = nil
