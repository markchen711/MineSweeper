Board = Class{}

-- Initialize board
function Board:init(grid, bombsNum)
    self.tiles = {}
    self.grid = grid -- grid x grid cells
    for i=1, grid do
        table.insert(self.tiles, {})
        for j=1, grid do
            self.tiles[i][j] = 0
        end
    end

    local bombs = bombsNum
    repeat
        local x = math.random(grid)
        local y = math.random(grid)
        if self.tiles[x][y] == 0 then
            self.tiles[x][y] = 9
            bombs = bombs - 1
        end
    until (bombs == 0)

    -- Mark number
    for i=1, grid do
        for j=1, grid do
            if self.tiles[i][j] ~= 9 then
                self:markNumber(i, j)
            end
        end
    end

    -- print("Debug log")
    -- local count = 0
    -- for i=1, grid do       
    --     for j=1, grid do
    --         io.write(" | "..self.tiles[i][j].." | ")
    --         if self.tiles[i][j] == 9 then
    --             count = count + 1
    --         end
    --     end
    --     print("")
    -- end
    -- print("Number of bombs: "..count)
end

function Board:markNumber(y, x)
    local limit = #self.tiles
    local count = 0
    for i=y-1, y+1 do
        for j=x-1, x+1 do
            if i <= limit and i >= 1 and j <= limit and j >= 1 then
                if self.tiles[i][j] == 9 then
                    count = count + 1
                end
            end
        end
    end
    self.tiles[y][x] = count
end

function Board:cellNeighbors(y, x)
    local limit = #self.tiles
end