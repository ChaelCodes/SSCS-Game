module Scenes
  class Break < Scenes::Game
    name :break

    # Handle rendering the scene here
    def render
      outputs.primitives << [
        { w: 1280, h: 720, r: 4, g: 20, b: 69 }.solid,
        @scene_button,
        { x: 500, y: 66, text: 'Back to Work', size_enum: 10, r: 250, g: 250, b: 250 }.label
      ]
      outputs.primitives << meters.map(&:render)
    end
    
    # Handle inputs here
    def input
      state.next_scene = :task if args.inputs.keyboard.key_down.b
      if args.inputs.mouse.click && (args.inputs.mouse.click.intersect_rect? @scene_button)
        state.next_scene = :task
      end
    end
    
    # Update game state
    def calc
      state.pee -= 0.005
      state.poop -= 0.02
      super
      @task.reset_progress
    end
  end
end
