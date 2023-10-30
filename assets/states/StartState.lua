StartState = Class{}

function StartState:init()
end

function StartState:update(dt)
    if love.keyboard.wasPressed("return") or 
    love.keyboard.wasPressed("enter") then
        stateMachine._states.playingState = PlayingState(9, 10)
        stateMachine:changeState("playing")
    end
end

function StartState:render()
    for i, v in pairs(gQuads.tiles) do
        love.graphics.draw(gTextures.sprites, v, i * 34 + 34, 34, 0,
            1, 1)
    end
end