module Scenes
  class Pause < Scene
    name :pause

    def defaults; end
    
    # Render the Pause Scene
    def render
      outputs.primitives << [
        { w: 1280, h: 720, r: 0, g: 0, b: 0}.solid,
        { x: 640, y: 460, text: "Pausing? There is no pause on life. Your body doesn't take a break.", r: 255, g: 255, b: 255, size_enum: 5, alignment_enum: align(:center) }.label
      ]
    end
    
    def input
      state.next_scene = :game if inputs.keyboard.key_down.p
    end
    
    def calc
      return
    end
  end
end
