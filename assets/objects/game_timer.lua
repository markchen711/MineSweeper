GameTimer = Class{}

function GameTimer:init()
    self.timer = 0
end

function GameTimer:update(dt)
    self.timer = self.timer + dt
end