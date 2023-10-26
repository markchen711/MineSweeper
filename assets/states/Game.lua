require "assets/objects/board" 
require "assets/objects/flag" 
Game = Class{}

function Game:init(grid, bombs)
    self.board = Board(grid, bombs)
    self.opened = {}
    self.flagged = {}

    self.tilesize = VIRTUAL_WIDTH/(#self.board.tiles+2)
    self.renderScale = 10/(#self.board.tiles+2)
end

function Game:update(dt)
    for k, v in pairs(self.flagged) do
        v:update(dt)
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

    for k, value in pairs(self.flagged) do
        value:render(tilesize, renderScale)
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
    for i, flag in pairs(self.flagged) do
        if flag.col == cCol and flag.row == cRow then
            table.remove(self.flagged, i)
            return
        end
    end
    self.opened[tostring(cRow).."-"..tostring(cCol)] = true
    if self.board.tiles[cRow][cCol] == 0 then
        self:expanding(cRow, cCol)
    end
end

function Game:expanding(y, x)
    local limit = #self.board.tiles
    for i=y-1, y+1 do
        for j=x-1, x+1 do
            if i <= limit and i >= 1 and j <= limit and j >= 1 then
                if self.board.tiles[i][j] ~= 9 and 
                    not self.opened[tostring(i).."-"..tostring(j)] then

                    self.opened[tostring(i).."-"..tostring(j)] = true
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
    for i, flag in pairs(self.flagged) do
        if flag.col == cCol and flag.row == cRow then
            table.remove(self.flagged, i)
            return
        end
    end
    table.insert(self.flagged, Flag(cRow, cCol))
end