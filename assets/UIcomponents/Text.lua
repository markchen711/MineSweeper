Text = Class{}

-- local font = love.graphics.newImageFont("assets/fonts/love2d-fonts.png",
-- " abcdefghijklmnopqrstuvwxyz" ..
-- "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
-- "123456789.,!?-+/():;%&`'*#=[]\"")
-- love.graphics.setFont(font)
local font_path = "assets/fonts/ArcadeAlternate.TTF"

local fonts = {
    h1 = love.graphics.newFont(font_path, 72),
    h2 = love.graphics.newFont(font_path, 63),
    h3 = love.graphics.newFont(font_path, 54),
    h4 = love.graphics.newFont(font_path, 45),
    h5 = love.graphics.newFont(font_path, 36),
    h6 = love.graphics.newFont(font_path, 27),
    p = love.graphics.newFont(font_path, 16)
}

function Text:init(params)
    self.text = params.text or "null"
    self.x = params.x or 0
    self.y = params.y or 0
    self.font_size = params.font_size or p
    self.wrap_with = params.wrap_with or VIRTUAL_WIDTH
    self.align = params.align or "left"
    self.color = params.color or {255,255,255}
    self.opacity = params.opacity or 1

    local fadeout_f = function() Timer.tween(1.6, {[self] = {opacity = 0}}) end

    if params.fade_in then
        Timer.tween(1.6, {
            [self] = {opacity = 1}
        }):finish(function() Timer.after(2, fadeout_f) end)
    end
end

function Text:render()
    love.graphics.setColor(
        self.color[1]/255, 
        self.color[2]/255, 
        self.color[3]/255,
        self.opacity)
    love.graphics.setFont(fonts[self.font_size])
    love.graphics.printf(self.text, self.x, self.y, self.wrap_with, self.align)
    love.graphics.setColor(1,1,1)
end

function Text:changeTextColor(r,g,b)
    self.color = {r,g,b}
end

function Text:changeText(text)
    self.text = text
end