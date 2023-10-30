gLibs = 'assets/libs/'
gSprites = 'assets/sprites/'
gUtils = 'assets/utils/'
gObjects = 'assets/objects/'
gStates = 'assets/states/'
gUIs = 'assets/UIcomponents/'
Class = require (gLibs .. 'class')
Event = require (gLibs ..'knife.event')
push = require (gLibs .. 'push')
Timer = require (gLibs ..'knife.timer')
suit = require (gLibs.."suit")

require (gUtils.."utils")
require (gSprites.."sprites")

--UI components
require (gUIs.."Text")
MenuUI = require (gUIs.."MenuUI")

-- Game components
require (gObjects.."board")
require (gObjects.."flag")
require (gObjects.."game_timer")
require (gStates.."Game")
require (gStates.."StateMachine")

-- Game states
require (gStates.."StartState")
require (gStates.."PlayingState")

