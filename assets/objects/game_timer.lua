GameTimer = Class{}

function GameTimer:init()
    self.timer = 0
end

function GameTimer:update(dt)
    self.timer = self.timer + dt
end

function GameTimer:render()
    love.graphics.setFont(lovefont)
    love.graphics.printf(tostring(math.floor(self.timer)), 0, 5, VIRTUAL_WIDTH,
        "center")
end