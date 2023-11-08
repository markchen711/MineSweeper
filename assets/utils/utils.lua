function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function advancedQuads(atlas, params)
    local sheetWidth = atlas:getWidth()
    local sheetHeight = atlas:getHeight()

    local sheetCounter = params.startIndex or 1
    local startX = params.startX or 0
    local startY = params.startY or 0
    local hMargin = params.hMargin or 0
    local vMargin = params.vMargin or 0

    spritesheet = {}

    for i = 0, params.colsNum-1 do
        for j = 0, params.perRow-1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(startX+j*hMargin+j*params.tileWidth, 
                startY+i*vMargin+i*params.tileHeight, 
                params.tileWidth,
                params.tileHeight, 
                atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end
    return spritesheet
end

function inList(el, array)
    -- Return index of that element in array, false otherwise
    local index = 0
    if type(el) == 'table' then
        for k, v in pairs(array) do
            index = index + 1  
            if table.concat(v, ",") == table.concat(el, ",") then
                return index
            end
        end
    else for k, v in pairs(array) do 
            index = index+1 
            if v == el then return index end
        end
    end
    return false
end

function properSubset(array, other)
    if #array >= #other or array==other then
        return false 
    else
        for k, v in pairs(array) do
            if not inList(v, other) then return false end
        end
        return true
    end
end

function diff_propersubset(array, other)
    if properSubset(array, other) then
        local diff = {}
        for k, v in pairs(other) do
            if not inList(v, array) then table.insert(diff, v) end
        end
        return diff
    end
    return nil
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function union(tbl, other)
    -- simply merge 2 tables, without using inList method
    for _, v in pairs(other) do
        table.insert(tbl, v)
    end
end

function merge_tables(table, other)
    for _, v in pairs(other) do
        if not inList(v, table) then table.insert(table, v) end
    end
end

-- function remove_duplicates(tbl)
--     local result = {}
--     local seen = {}
 
--     for _, value in pairs(tbl) do
--         if not seen[value] then
--             table.insert(result, value)
--             seen[value] = true
--         end
--     end
--     return result
-- end