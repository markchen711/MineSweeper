gTextures = {
    sprites = love.graphics.newImage(gSprites.."custom-minesweeper.png"),
    flags = love.graphics.newImage(gSprites.."flags.png"),
    bg = love.graphics.newImage(gSprites.."bg.png"),
    bgdeck = love.graphics.newImage(gSprites.."shipdeck.png")
}

gQuads = {
    tiles = advancedQuads(gTextures.sprites, {
        startIndex=-1,
        startX=10,
        startY=30,
        hMargin=3,
        perRow=12,
        colsNum=1,
        tileWidth=30,
        tileHeight=30
    }),
    flag = advancedQuads(gTextures.flags, {
        startX=7,
        startY=80,
        perRow=3,
        colsNum=1,
        hMargin=6,
        tileWidth=18,
        tileHeight=24
    }),
    preFlag = advancedQuads(gTextures.flags, {
        perRow=9,
        colsNum=1,
        tileWidth=18,
        tileHeight=24
    })
}
