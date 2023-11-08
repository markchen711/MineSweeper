require "assets/objects/board" 
require "assets/objects/flag" 
require "assets/objects/hint_ai" 
Game = Class{}

local resultText = Text({x=0, y=VIRTUAL_WIDTH/2.3, font_size="h3",
    align="center", color={138,187,42}})

function Game:init(grid, bombs)
    self.board = Board(grid, bombs)
    self.flagged = {} -- *hash table
    self.opened = {}  -- *hash table
    self.tilesize = VIRTUAL_WIDTH/(#self.board.tiles+2)
    self.renderScale = 10/(#self.board.tiles+2)

    -- To improve speed, everytime I add new entry to the table, increment count
    -- by 1, instead of looping and count entries per frame to check for winning
    -- condition
    self.bombs = bombs
    self.openedCount = 0
    self.expaneded = {} -- hash table / Deprecated
    self.state = "playing" -- "won" -- "lost"
    self.resultText = nil

    -- helper ai
    self.ai = HelperAI(grid, grid)
    self.aiOn = true
end

function Game:update(dt)
    for k, v in pairs(self.flagged) do
        v:update(dt)
    end
    if love.keyboard.wasPressed("i") then
        for strkey, _ in pairs(self.ai.safes) do
            local cell = mysplit(strkey, "-")
            local y, x = tonumber(cell[1]), tonumber(cell[2])
            self:openCell(x*self.tilesize+1, y*self.tilesize+1)
        end
    end
end

function Game:render()
    local tilesize = self.tilesize
    local renderScale = self.renderScale

    for i=1, #self.board.tiles do
        for j=1, #self.board.tiles[i] do
            if self.opened[tostring(i).."-"..tostring(j)] then
                love.graphics.draw(gTextures.sprites, 
                gQuads.tiles[self.board.tiles[i][j]],
                j*tilesize, i*tilesize, 
                0, renderScale, renderScale)
            else
                love.graphics.draw(gTextures.sprites, 
                gQuads.tiles[-1],
                j*tilesize, i*tilesize, 
                0, renderScale, renderScale)
            end
        end
    end

    for entry, flag in pairs(self.flagged) do
        if flag ~= nil then
            flag:render(tilesize, renderScale)
        end
    end

    if self.state ~= "playing" then
        self.resultText:render()
    end

    if self.aiOn then
        for i=1, #self.board.tiles do
            for j=1, #self.board.tiles[i] do
                if self.ai.safes[tostring(i).."-"..tostring(j)] then
                    love.graphics.setColor(.54, .73, .16, .35)
                    love.graphics.rectangle("fill",
                    j*tilesize, i*tilesize, tilesize, tilesize)
                elseif self.ai.bombs[tostring(i).."-"..tostring(j)] then
                    love.graphics.setColor(1, 0, 0, .35)
                    love.graphics.rectangle("fill",
                    j*tilesize, i*tilesize, tilesize, tilesize)
                end
            end
        end
        love.graphics.setColor(1,1,1)
    end
end

function Game:openCell(x, y)
    -- Get corresponding cell based on x, y coordinate
    local cCol = math.floor(x/self.tilesize)
    local cRow = math.floor(y/self.tilesize)
    if cCol < 1 or cCol > #self.board.tiles or 
    cRow < 1 or cRow > #self.board.tiles then
        return
    end
    if self.flagged[tostring(cRow).."-"..tostring(cCol)] or
        self.opened[tostring(cRow).."-"..tostring(cCol)] then
        return
    end

    self.opened[tostring(cRow).."-"..tostring(cCol)] = true
    self.openedCount = self.openedCount + 1
    SFX:play('click')

    if self.board.tiles[cRow][cCol] == 0 then
        self:expanding(cRow, cCol)
    --     self.ai:reset_knowledgebase()
    -- elseif self.board.tiles[cRow][cCol] < 9 then
    --     self.ai:add_knowledge(cRow, cCol, self.board.tiles[cRow][cCol])
    end
    self.ai:reset_knowledgebase()

    if self.board.tiles[cRow][cCol] == 9 then
        self.resultText = Text({text="YOU LOST", x=0, y=VIRTUAL_WIDTH/2.3, 
            font_size="h3",align="center", color={221,160,221}, opacity=0,
            fade_in=true, fade_out=true})
        SFX:play("explosion")
        self.state = "lost"

    elseif self.openedCount == 
    #self.board.tiles*#self.board.tiles[1]-self.bombs then
        self.resultText = Text({text="YOU WON", x=0, y=VIRTUAL_WIDTH/2.3, 
            font_size="h3",align="center", color={138,187,42}, opacity=0,
            fade_in=true, fade_out=true})
        self.state = "won"
        SFX:play("win")
    end
end

function Game:expanding(y, x)
    local limit = #self.board.tiles
    for i=y-1, y+1 do
        for j=x-1, x+1 do
            if i <= limit and i >= 1 and j <= limit and j >= 1 then
                local entry = tostring(i).."-"..tostring(j)
                if not self.opened[entry] then

                    self.opened[entry] = true
                    self.openedCount = self.openedCount + 1
                    
                    if self.flagged[entry] then
                        self.flagged[entry] = nil
                    end

                    if self.board.tiles[i][j] == 0 then
                        self:expanding(i, j)
                    end
                end
            end
        end
    end
end

function Game:flag(x, y)
    local cRow = math.floor(y/self.tilesize)
    local cCol = math.floor(x/self.tilesize)
    if cCol < 1 or cCol > #self.board.tiles
        or cRow < 1 or cRow > #self.board.tiles 
        or self.opened[tostring(cRow).."-"..tostring(cCol)] then
        return
    end

    -- for i, flag in pairs(self.flagged) do
    --     if flag.col == cCol and flag.row == cRow then
    --         table.remove(self.flagged, i)
    --         return
    --     end
    -- end
    -- table.insert(self.flagged, Flag(cRow, cCol))


    if self.flagged[tostring(cRow).."-"..tostring(cCol)] then
        -- removing flag if right click again
        self.flagged[tostring(cRow).."-"..tostring(cCol)] = nil
    else
        -- Store as hashtable instead of continuous int table to easy track when
        -- performing expanding
        self.flagged[tostring(cRow).."-"..tostring(cCol)] = Flag(cRow, cCol)
    end
end