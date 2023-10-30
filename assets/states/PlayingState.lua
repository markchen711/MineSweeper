PlayingState = Class{}

function PlayingState:init(grid, bombs)
    local _grid = grid or 8
    local _bombs = bombs or 10
    self.game = Game(_grid, _bombs)
    self.gametimer = GameTimer()
end

function PlayingState:update(dt)
    if love.keyboard.wasPressed("p") then
        stateMachine:changeState("paused")
    elseif love.keyboard.wasPressed("n") then
        stateMachine:changeState("menu")
    end

    if love.mouse.leftClick then
        self:mouseClick(true)
    elseif love.mouse.rightClick then
        self:rightClick(true)
    end
    self.game:update(dt)
    if self.game.state == "playing" then
        self.gametimer:update(dt)
    end
end

function PlayingState:render()
    self.game:render()
    self.gametimer:render()
end

function PlayingState:mouseClick(clicked)
    -- If not click then it can perform hovering
    local mouse_x, mouse_y = push:toGame(love.mouse.getPosition())
    if clicked then
        if self.game.state == "playing" then
            self.game:openCell(mouse_x, mouse_y)
        end
    end
end

function PlayingState:rightClick(clicked)
    local mouse_x, mouse_y = push:toGame(love.mouse.getPosition())
    if clicked then
        if self.game.state == "playing" then
            self.game:flag(mouse_x, mouse_y)
        end
    end
end