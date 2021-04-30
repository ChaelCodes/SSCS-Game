class Game
  attr_gtk

  def initialize(args)
    self.args = args
  end

  def tick
    defaults
    Scene.registered_scenes.each do |scene|
      klazz = Object.const_get("Scenes::#{scene.capitalize}")
      ivar = "@#{scene}_scene".to_sym
      instance_variable_set(ivar, klazz.new(args)) unless instance_variable_get ivar
      instance_variable_get(ivar).tick
    end
    input
    state.scene = state.next_scene if state.next_scene != :none
    if !Scene.registered_scenes.include? state.scene
      log_once state.scene, "* Warning: #{state.scene} doesn't have a Scene class associated with it. Please run scaffold_scene \"Name\" in the game console."
    end
    state.next_scene = :none
  end

  def defaults
    state.scene ||= :task
    state.money ||= 0
  end

  # Render Order
  # Solids
  # Sprites
  # Primitives
  # Labels
  # Lines
  # Borders
  # Debug

  def input
    state.next_scene = :pause if inputs.keyboard.key_down.p
    # save
    if args.inputs.keyboard.key_down.t
      $gtk.save_state
    end
    # load
    if args.inputs.keyboard.key_down.r
      $gtk.load_state
    end
  end
end
