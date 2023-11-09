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
                if not game.opened[tostring(i).."-"..tostring(j)] 
                and not self.safes[tostring(i).."-"..tostring(j)] then
                    table.insert(neighbors, {i, j})
                end
            end
        end
    end
    return neighbors
end

function HelperAI:add_knowledge(cRow, cCol, count)
    -- Add single knowledge
    --[[
    Currently not working really well as knowledge_base is over cleaned and
    make it hard to create new inference, as you can see from new_inference 
    method, new inference's only created based on other sentences in knowledge
    base and have naught to do with index in self.opened. I will try to overcome
    this problem if I can, just use reset_knowledgebase, it's still very
    efficient]]
    local entry = tostring(cRow).."-"..tostring(cCol)
    local cell_neighbors = self:neighbors(cRow, cCol)
    table.insert(self.knowledge_base, Sentence(cell_neighbors, count))
    if not self.safes[entry] then self.safes[entry] = true end

    self:new_inference()
    self:update_bombs_safes()
    self.knowledge_base = self:kb_cleaned()
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
    union(self.knowledge_base, new_inferences)

    -- debug
    -- self:debug_knowledgebase()
end

function HelperAI:reset_knowledgebase()
    -- Used after board is expanded when hit 0 cell instead of adding knowledge
    -- every expanding step
    self.knowledge_base = {}
    self.safes = {}
    local game = stateMachine._states.playingState.game
    for i=1, #game.board.tiles do
        for j=1, #game.board.tiles[i] do
            if game.opened[tostring(i).."-"..tostring(j)]  then
                if game.board.tiles[i][j] > 0 and game.board.tiles[i][j] < 9 then
                    table.insert(self.knowledge_base,
                        Sentence(self:neighbors(i, j), game.board.tiles[i][j]))
                end
            end
        end
    end
    self.knowledge_base = self:kb_cleaned()
    self:new_inference()
    self:update_bombs_safes()
    self.knowledge_base = self:kb_cleaned()
    self:update_bombs_safes()
    -- debug
    -- self:debug_knowledgebase()
end

function HelperAI:update_bombs_safes()
    for _, sentence in pairs(self.knowledge_base) do
        if #sentence.cells == sentence.count then
            -- for k, cell in pairs(sentence.cells) do
            for i=#sentence.cells, 1, -1 do
                self.bombs[table.concat(sentence.cells[i], "-")] = true
                self:update_sentences(sentence.cells[i], 'markbomb')
            end
        elseif sentence.count == 0 then
            for i=#sentence.cells, 1, -1 do
                self.safes[table.concat(sentence.cells[i], "-")] = true
                self:update_sentences(sentence.cells[i], 'marksafe')
            end
        end
    end
    -- print("bombs!!!")
    -- for k, v in pairs(self.bombs) do io.write(k..", ") end
    -- print("")

    -- print("safe moves")
    -- for k, v in pairs(self.safes) do io.write(k..", ") end
    -- print("")
end

function HelperAI:update_sentences(cell, callback)
    for _, sentence in pairs(self.knowledge_base) do
        if callback == 'markbomb' then sentence:markBomb(cell)
        else sentence:markSafe(cell) end
    end
end

function HelperAI:kb_cleaned()
    local seen_sentences = {}
    local cleaned_tbl = {}
    for _, sentence in pairs(self.knowledge_base) do
        if #sentence.cells ~= 0 then
            local cells = ""
            for k, cell in pairs(sentence.cells) do
                cells = cells..table.concat(cell,"-")..","
            end
            if not seen_sentences[cells] then
                table.insert(cleaned_tbl, sentence)
                seen_sentences[cells] = true
            end
        end
    end
    return cleaned_tbl
end

function HelperAI:debug_knowledgebase()
    for _, sentence in pairs(self.knowledge_base) do
        for _, cell in pairs(sentence.cells) do
            io.write(cell[1]) io.write("-") io.write(cell[2]) io.write(", ")
        end io.write("   "..sentence.count)
        print("")
    end
end
