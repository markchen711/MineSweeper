gLibs = 'assets/libs/'
gSprites = 'assets/sprites/'
gUtils = 'assets/utils/'
gObjects = 'assets/objects/'
gStates = 'assets/states/'
Class = require (gLibs .. 'class')
Event = require (gLibs ..'knife.event')
push = require (gLibs .. 'push')
Timer = require (gLibs ..'knife.timer')

require (gUtils.."utils")
require (gSprites.."sprites")

-- Game components
require (gObjects.."board")
require (gObjects.."flag")
require (gStates.."Game")
require (gStates.."StateMachine")

-- Game states
require (gStates.."StartState")
require (gStates.."PlayingState")

playingState = nil
stateMachine = StateMachine()
