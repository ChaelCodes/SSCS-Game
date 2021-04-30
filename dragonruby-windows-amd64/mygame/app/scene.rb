class Scene
    attr_gtk

    def self.registered_scenes
      @@registered_scenes || []
    end

    def self.name value
      raise "Name must be a symbol #{value}" unless value.is_a? Symbol
      @@registered_scenes ||= []
      @@registered_scenes << value
      @@registered_scenes.reject! { |s| s.is_a? Hash }
      @@registered_scenes.uniq!

      define_method :name do
        value
      end
    end

    def initialize(args)
      self.args = args
    end

    def tick
      return unless state.scene == name
      current_scene = state.scene
      __defaults__
      __render__
      __input__
      __calc__
      raise "You are not allowed to change state.scene, please set state.next_scene instead. Currently in #{current_scene}." if state.scene != current_scene
    end

    def __defaults__
      defaults
    end

    def __render__
      render
    end

    def __input__
      state.next_scene = :pause if inputs.keyboard.key_down.p
      input
    end

    def __calc__
      calc
    end

    def defaults
    end

    def render
    end

    def input
    end

    def calc
    end
end
