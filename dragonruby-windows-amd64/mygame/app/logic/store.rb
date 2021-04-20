class Store
  attr_gtk
  attr :items

  def initialize(args:)
    self.args = args
    @exit = {x: 858, y: 605, w: 14, h: 20, r: 180, g: 20, b: 20}.solid
    init_items
  end

  def init_items
    self.items = []
    items << Store::Item.new(args, "Granola Bar", 2, 'sprites/granola-small.png', 6, 2)
    items << Store::Item.new(args, "Organic Bar", 3, 'sprites/granola-small.png', 8, 2)
  end

  def input
    items[0]&.buy if args.inputs.keyboard.key_down.zero
    items[1]&.buy if args.inputs.keyboard.key_down.one
    return unless args.inputs.mouse.click
    click = args.inputs.mouse.click
    items.each do |item|
      item.buy if click.intersect_rect? item.background
    end
    close if args.inputs.mouse.click.intersect_rect? @exit
  end

  def close
    args.state.store = false
  end

  def open
    args.state.store = true
  end

  def laptop_store_scene
    args.outputs.primitives << [
      # Layout
      {x: 330, y: 335, w: 556, h: 308, r: 100, g: 100, b: 100}.solid,
      @exit,
      {x: 860, y: 625, text: 'X', r: 175, g: 175, b: 175}.label,
      { x: 340, y: 370, text: "Money: $#{state.money}", size_enum: 5, alignment_enum: align(:left) }.label,
    ]
    args.outputs.primitives << items.map(&:render)
  end

  def reset
    args.state.store = false
  end

  Item = Struct.new :args, :name, :cost, :sprite, :col, :row do
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
        args.state.granola_count += 1
      end
    end
  end
end

$gtk.reset
$game = nil
