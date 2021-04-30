module Scenes
  class Death < Scene
    name :death

    # Set defaults for any state values used
    def defaults; end

    # Handel rendering the scene here
    def render
      outputs.primitives << [
        { w: 1280, h: 720, r: 0, g: 0, b: 0}.solid,
        { x: 640, y: 460, text: 'You have died.', r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label,
        { x: 640, y: 400, text: state.death_message, r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label,
        { x: 640, y: 340, text: "You made $#{state.money}, and survived #{state.time_of_death.fdiv(3600).to_sf} minutes.", r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label
      ]
    end
    
    # Handle inputs here
    def input
      if args.inputs.mouse.click
        reset if state.time_of_death.elapsed_time > 60
      end
    end
    
    # Update game state
    def calc; end

    def reset
      Kernel.tick_count = 0
      gtk.reset_state
      state.next_scene = :task
    end
  end
end
