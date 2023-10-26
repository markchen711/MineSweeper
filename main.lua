--[[
    Hello, My name is Mark Chen
]]

require 'assets/requirements'
require 'global'

function love.load()
    math.randomseed(os.time())
    -- love.window.setTitle("Mine Sweeper - Have fun!")
    love.graphics.setDefaultFilter("nearest", "nearest")

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = true
    })
    love.keyboard.keysPressed = {}
    love.mouse.leftClick = false
    love.mouse.rightClick = false
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == "escape" then
        love.event.quit()
    end
    if key == "f" then
        board = Board(8, 10)
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        love.mouse.leftClick = true
    elseif button == 2 then
        love.mouse.rightClick = true
    end
end

function love.update(dt)
    stateMachine:update(dt)
    love.mouse.leftClick = false
    love.mouse.rightClick = false
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.setBackgroundColor(40/255, 70/255, 92/255)
    stateMachine:render()
    push:finish()
end
    