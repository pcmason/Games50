--function used to generate all images
function GenerateQuads(atlas,tilewidth,tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 0, sheetHeight -1 do 
        for x = 0, sheetWidth -1 do 
            spriteSheet[sheetCounter]= 
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end
--function used for images with similar things throughout. 
-- i.e. the hearts or arrows .png files
function table.slice(tbl,first,last,step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do 
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end
--function used to generate paddles
function GenerateQuadsPaddles(atlas)
    --location of where paddles can first be found
    local x = 0 
    local y = 64

    local counter = 1
    local quads = {}
    --creates the possibility to have small, medium, large or extra large paddles
    for i = 0,3 do 
        quads[counter] = love.graphics.newQuad(x,y,32,16,atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x+32,y,64,16,atlas:getDimensions())
        counter = counter +1 
        quads[counter] = love.graphics.newQuad(x + 96, y,96,16,atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x,y+16,128,16,atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end
    return quads
end

--function to create the image for the balls
function GenerateQuadsBalls(atlas)
    --begginning location of balls in quad sheet
    x = 96
    y = 48

    local counter = 1 
    local quads = {}
    --since balls are split into two rows need two for loops to get all colors
    for i = 0,3 do 
        quads[counter] = love.graphics.newQuad(x,y,8,8,atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end
    --location at begginning of second row
    x = 96
    y = 56
    for i =0,2 do 
        quads[counter] = love.graphics.newQuad(x,y,8,8,atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end
    return quads
end
--function used to generate brick types
function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas,32,16),1,21)
end
--function used to generate different powerups
function GenerateQuadsPowerups(atlas)
    --start location of powerups on quad sheet
    local x = 0
    local y = 192

    local counter = 1
    local quads = {}
    --go through all 9 different powerups
    for i =0, 9 do
        quads[counter] = love.graphics.newQuad(x,y,16,22,atlas:getDimensions())
        x = x + 16
        counter = counter + 1
    end
    return quads
end




