module Scenes
  class Task < Scenes::Game
    name :task

    # Set defaults for any state values used
    def defaults
      super
    end

    # Handle rendering the scene here
    def render
      super
      outputs.primitives << { x: 500, y: 66, text: 'Take a Break', size_enum: 10, r: 250, g: 250, b: 250 }.label
    end
    
    # Handle inputs here
    def input
      super
    end
    
    # Update game state
    def calc
      super
      @task.calc
    end
  end
end
