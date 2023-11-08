HelperAI = Class{}
require (gObjects.."ai_sentence")
--[[ 
]]
function HelperAI:init(width, height)
    self.knowledge_base = {}
    self.bombs = {} -- hash table
    self.safes = {} -- hash table
    self.width = width
    self.height = height
end

function HelperAI:neighbors(cRow, cCol)
    local neighbors = {}
    local game = stateMachine._states.playingState.game
    for i=cRow-1, cRow+1 do
        for j=cCol-1, cCol+1 do
            if i > 0 and i <= self.height and j > 0 and j <= self.width then
                if not game.opened[tostring(i).."-"..tostring(j)] then
                    table.insert(neighbors, {i, j})
                end
            end
        end
    end
    return neighbors
end

function HelperAI:add_knowledge(cRow, cCol, count)
    local entry = tostring(cRow).."-"..tostring(cCol)
    local cell_neighbors = self:neighbors(cRow, cCol)
    table.insert(self.knowledge_base, Sentence(cell_neighbors, count))
    if not self.safes[entry] then self.safes[entry] = true end

    self:new_inference()
    self:update_bombs_safes()
end

function HelperAI:new_inference()
    local new_inferences = {}
    for k1, sentence in pairs(self.knowledge_base) do
        for k2, other in pairs(self.knowledge_base) do
            if k1 ~= k2 then
                local subset = diff_propersubset(sentence.cells, other.cells)
                if subset then
                    table.insert(new_inferences,
                        Sentence(subset, other.count-sentence.count))
                end
            end
        end
    end
    print(#self.knowledge_base)
    union(self.knowledge_base, new_inferences)
    print("after make new inferences")
    print(#self.knowledge_base)
    for _, sentence in pairs(self.knowledge_base) do
        for _, cell in pairs(sentence.cells) do
            io.write(cell[1]) io.write("-") io.write(cell[2]) io.write(", ")
        end io.write("   "..sentence.count)
        print("")
    end
end

-- function HelperAI:inference() end

function HelperAI:reset_knowledgebase()
    -- Used after board is expanded when hit 0 cell
    self.knowledge_base = {}
    local game = stateMachine._states.playingState.game
    for i=1, #game.board.tiles do
        for j=1, #game.board.tiles[i] do
            if game.board.tiles[i][j] > 0 and game.board.tiles[i][j] < 9 then
                if game.opened[tostring(i).."-"..tostring(j)]  then
                    table.insert(self.knowledge_base,
                        Sentence(self:neighbors(i, j), game.board.tiles[i][j]))
                end
            end
        end
    end
    self.knowledge_base = self:dup_cleaned()
    self:new_inference()
    self:update_bombs_safes()
end

function HelperAI:update_bombs_safes()
    for _, sentence in pairs(self.knowledge_base) do
        if #sentence.cells == sentence.count then
            for k, cell in pairs(sentence.cells) do
                self.bombs[table.concat(cell, "-")] = true
            end
        else 
            if sentence.count == 0 then
                for k, cell in pairs(sentence.cells) do
                    self.safes[table.concat(cell, "-")] = true
                end
            end
        end
    end
    for k, v in pairs(self.bombs) do io.write(k..", ") end
end

function HelperAI:dup_cleaned()
    local seen_sentences = {}
    local cleaned_tbl = {}
    for _, sentence in pairs(self.knowledge_base) do
        local cells = ""
        for k, cell in pairs(sentence.cells) do
            cells = cells..table.concat(cell,"-")..","
        end
        if not seen_sentences[cells] then
            table.insert(cleaned_tbl, sentence)
            seen_sentences[cells] = true
        end
    end
    return cleaned_tbl
end
