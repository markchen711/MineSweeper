local input = {text = ""}
local MenuUI = {}

-- MenuUI.update = function(dt) return end

function MenuUI.update(dt)
    suit.layout:reset(0,0)
    love.graphics.setFont(lovefont)

	-- put an input widget at the layout origin, with a cell size of 200 by 30 pixels
	-- suit.Input(input, suit.layout:row(100,25))

	-- put a label that displays the text below the first cell
	-- the cell size is the same as the last one (200x30 px)
	-- the label text will be aligned to the left
	-- suit.Label("Hello, "..input.text, {align = "left"}, suit.layout:row())

	-- put an empty cell that has the same size as the last cell (200x30 px)
    if stateMachine.states.menu then
        local button_width = 100
        local padding_x = (push:getWidth()-button_width)/2
        local padding_y = VIRTUAL_HEIGHT/3.5
        suit.layout:reset(padding_x, padding_y)
        suit.layout:row(button_width, 25)
        if suit.Button("Easy", suit.layout:row()).hit then
            stateMachine._states.playingState = PlayingState(8, 9)
            stateMachine:changeState("playing")
            SFX:play('start')
        elseif suit.Button("Medium", suit.layout:row()).hit then
            stateMachine._states.playingState = PlayingState(12, 35)
            stateMachine:changeState("playing")
            SFX:play('start')
        elseif suit.Button("Hard", suit.layout:row()).hit then
            stateMachine._states.playingState = PlayingState(20, 52)
            stateMachine:changeState("playing")
            SFX:play('start')
        elseif suit.Button("Extreme", suit.layout:row()).hit then
            stateMachine._states.playingState = PlayingState(28, 129)
            stateMachine:changeState("playing")
            SFX:play('start')
        elseif suit.Button("Quit", suit.layout:row()).hit then
            love.event.quit()
        end
    elseif stateMachine.states.playing then
        suit.layout:reset(210, 0)
        if suit.Button("Menu", suit.layout:row(45, 13)).hit then
            stateMachine:changeState("menu")
        end
        suit.layout:reset(255, 0)
        if suit.Button("Quit", suit.layout:row(45, 13)).hit then
            love.event.quit()
        end
        suit.layout:reset(0, 0)
        if suit.Button("AI Hint", suit.layout:row(65, 13)).hit then
            stateMachine._states.playingState.game.aiOn =
                    not stateMachine._states.playingState.game.aiOn
        end
    end
end

function MenuUI.render()
    suit.draw()
end

return MenuUI