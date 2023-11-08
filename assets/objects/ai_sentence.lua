Sentence = Class{}

function Sentence:init(cells, count)
    self.cells = cells
    self.count = count
end

function Sentence:markSafe(cell)
    -- Mark a cell in sentence as safe
    local in_cells = inList(cell, self.cells)
    if in_cells then table.remove(self.cells, in_cells) end
end

function Sentence:markBomb(cell)
    local in_cells = inList(cell, self.cells)
    if in_cells then 
        self.count = self.count - 1
        table.remove(self.cells, in_cells) 
    end
end