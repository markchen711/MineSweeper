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
