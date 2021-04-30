module Scenes
  class Store < Scenes::Game
    name :store
    attr :items

    def initialize(args)
      super
      @exit = {x: 858, y: 605, w: 14, h: 20, r: 180, g: 20, b: 20}.solid
      init_items
    end

    # Set defaults for any state values used
    # NOTE: YOU DO NOT NEED TO CALL SUPER IN THESE FUNCTIONA CHAEL
    # YEAH YOU DO AMIR
    def defaults
      super
    end

    # Handle rendering the scene here
    def render
      super
      args.outputs.primitives << [
        # Layout
        {x: 330, y: 335, w: 556, h: 308, r: 100, g: 100, b: 100}.solid,
        @exit,
        {x: 860, y: 625, text: 'X', r: 175, g: 175, b: 175}.label,
        { x: 340, y: 370, text: "Money: $#{state.money}", size_enum: 5, alignment_enum: align(:left) }.label,
        { x: 500, y: 66, text: 'Take a Break', size_enum: 10, r: 250, g: 250, b: 250 }.label
      ]
      args.outputs.primitives << items.map(&:render)
    end
    
    # Handle inputs here
    def input
      super
      items[0]&.buy if args.inputs.keyboard.key_down.zero
      items[1]&.buy if args.inputs.keyboard.key_down.one
      return unless args.inputs.mouse.click
      click = args.inputs.mouse.click
      items.each do |item|
        item.buy if click.intersect_rect? item.background
      end
      state.next_scene = :task if args.inputs.mouse.click.intersect_rect? @exit
    end

    def calc
      super
      @task.reset_progress
    end

    def init_items
      self.items = []
      give_granola = Proc.new { args.state.granola_count += 1 }
      items << Store::Item.new(args, "Granola Bar", 2, 'sprites/granola-small.png', 6, 2, give_granola)
      items << Store::Item.new(args, "Organic Bar", 3, 'sprites/granola-small.png', 8, 2, give_granola)
    end

    Item = Struct.new :args, :name, :cost, :sprite, :col, :row, :proc do
      def background
        args.layout.rect(col: col, row: row, w: 2, h: 2).merge(r: 200, g: 200, b: 200, a: 200).solid
      end

      def render
        [
          background,
          args.layout.rect(col: col, row: row, w: 2, h: 2, dx: 1, dy: 20).merge(text: name, size_enum: -2).label,
          args.layout.rect(col: col, row: row, w: 2, h: 2, dx: 1, dy: 10).merge(text: "$#{cost}").label,
          args.layout.rect(col: col, row: row, w: 2, h: 1).merge(w: 226 * 0.4, h: 101 * 0.4, path: sprite).sprite
        ]
      end

      def buy
        if args.state.money >= cost
          args.state.money -= cost
          proc.call
        end
      end
    end
  end
end
