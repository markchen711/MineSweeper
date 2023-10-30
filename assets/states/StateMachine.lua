StateMachine = Class{}

function StateMachine:init()
    self.states = {
        menu = true,
        paused = false,
        playing = false,
        gameover = false
    }
    self._states = {
        startState = StartState(),
        playingState = nil
    }
end

function StateMachine:changeState(state)
    assert(self.states[state] ~= nil)
    for _state, _ in pairs(self.states) do
        self.states[_state] = false
    end
    self.states[state] = true
end

function StateMachine:update(dt)
    if self.states.menu then
        self._states.startState:update(dt)
    elseif self.states.playing then
        self._states.playingState:update(dt)
    end
end

function StateMachine:render()
    -- love.graphics.setColor(1,1,1,0.8)
    -- love.graphics.draw(gTextures.bgdeck, 0, 0, 0, 
    --     VIRTUAL_HEIGHT/gTextures.bg:getHeight(),
    --     VIRTUAL_HEIGHT/gTextures.bg:getHeight())
    -- love.graphics.setColor(1,1,1,1)
    if self.states.menu then
        StartState:render()
    elseif self.states.playing then
        self._states.playingState:render()
    end
end