module Scenes
  class Game < Scene
    name :game
    attr :meters

    def initialize(args)
      super
      @water_bottle = { x: 1050, y: 105, w: 100, h: 266, path: 'sprites/bottle-small.png'}
      @granola_bar = { x: 20, y: 80, w: 226, h: 101, angle: 317, path: 'sprites/granola-small.png'}
      @store_icon = { x: 575, y: 340, w: 50, h: 50, path: 'sprites/cart.png'}
      @scene_button = { x: 485, y: 0, w: 260, h: 75, r: 20, g: 20, b: 20, a: 100}.solid
      init_meters
      @task = ::Task.new(args)
    end

    # Set defaults for any state values used
    def defaults
      state.granola_count ||= 10
      @task.defaults
      meters.each(&:defaults)
    end


    def granola_bars
      state.previous_granola_count ||= state.granola_count
      state.granola_bars = nil if state.previous_granola_count != state.granola_count
      state.previous_granola_count = state.granola_count
      state.granola_bars ||= state.granola_count.map_with_index do |i|
        @granola_bar.merge(angle: @granola_bar[:angle] + 10.randomize(:sign, :ratio), y: @granola_bar[:y] + i)
      end
    end

    # Handle rendering the scene here
    def render
      outputs.labels  << [600, 620, 'Sadistic Self-Care Survival Game!', 5, 1]
      outputs.primitives << meters.map(&:render)
      outputs.primitives << [
        @task.render,
        { x: 340, y: 370, text: "Money: $#{state.money}", size_enum: 5, alignment_enum: align(:left) }.label,
        { x: 80, y: 90, text: state.granola_count }.label,
        @scene_button
      ]
      outputs.debug << [30, 30.from_top, "#{args.inputs.mouse.point}"].label
  
      # Sprites
      outputs.sprites << [
        [0, 0, 1280, 720, 'sprites/laptop.png'],
        @water_bottle,
        granola_bars,
        @store_icon
      ]
    end
    
    # Handle inputs here
    def input
      if args.inputs.mouse.click
        if args.inputs.mouse.click.intersect_rect? @water_bottle
          state.water += 0.1
          # args.outputs.sounds << 'sounds/water.wav'
        end
        if args.inputs.mouse.click.intersect_rect? @granola_bar
          # Eat
          if state.granola_count > 0
            state.food += 0.1
            state.poop += 0.05
            state.granola_count -= 1
            state.granola_bars = nil
          end
        end
        if args.inputs.mouse.click.intersect_rect? @store_icon
          state.next_scene = :store
        end
        if args.inputs.mouse.click.intersect_rect? @scene_button
          state.next_scene = :break
        end
      end
      
      state.next_scene = :break if args.inputs.keyboard.key_down.b
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
    end
    
    # Update game state
    def calc
      state.task_rate = 1.0
      meters.each(&:calc)
    end

    def init_meters
      self.meters = [
        Meters::Food.new(args: args, row: 0, col: 0),
        Meters::Poop.new(args: args, row: 0, col: 1),
        Meters::Water.new(args: args, row: 0, col: 23),
        Meters::Pee.new(args: args, row: 0, col: 22)
      ]
    end
  end
end
