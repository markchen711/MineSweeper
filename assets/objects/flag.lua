Flag = Class{}

local flaggingInterval = 0.06
local flagInterval = 0.4

function Flag:init(row, col)
    self.state = "flagging"
    self.currentFrame = 1
    self.row = row
    self.col = col
    self.timer = 0
    self.quads = gQuads.preFlag
end

function Flag:update(dt)
    self.timer = self.timer + dt
    -- self.timer = (self.timer + dt)%flagInterval
    if self.state == "flying" then
        if self.timer > flagInterval then
            self.timer = 0
            self.currentFrame = math.max(1,
                ((self.currentFrame+1) % (#self.quads+1)))
        end
    else
        if self.timer > flaggingInterval then
            self.timer = 0
            self.currentFrame = self.currentFrame + 1
            if self.currentFrame == 10 then
                self.currentFrame = 1
                self.state = "flying"
                self.quads = gQuads.flag
            end
        end
    end
end

function Flag:render(tilesize, renderScale)
    local flagPaddingX = self.state == "flying" and math.floor(6 * renderScale) 
                            or math.floor(9 * renderScale)
    local flagPaddingY = math.floor(2 * renderScale)
    love.graphics.draw(gTextures.flags, 
        self.quads[self.currentFrame],
        self.col*tilesize+flagPaddingX, self.row*tilesize+flagPaddingY, 
        0, renderScale, renderScale)
end


