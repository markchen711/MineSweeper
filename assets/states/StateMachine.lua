StateMachine = Class{}

function StateMachine:init()
    self.states = {
        menu = true,
        paused = false,
        playing = false,
        gameover = false
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
        StartState:update(dt)
    elseif self.states.playing then
        playingState:update(dt)
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
        playingState:render()
    end
end