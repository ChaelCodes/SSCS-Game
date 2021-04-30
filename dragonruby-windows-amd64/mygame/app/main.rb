### Models
# Meters
require 'app/models/meter.rb'
require 'app/models/meters/food.rb'
require 'app/models/meters/inverse.rb'
require 'app/models/meters/pee.rb'
require 'app/models/meters/poop.rb'
require 'app/models/meters/water.rb'

require 'app/models/task.rb'

# Scenes
require 'app/scene.rb'
require 'app/scenes/death.rb'
require 'app/scenes/game.rb'
require 'app/scenes/break.rb' # Uses game.rb
require 'app/scenes/pause.rb'
require 'app/scenes/store.rb'
require 'app/scenes/task.rb'

require 'app/game.rb'
require 'app/tick.rb'
