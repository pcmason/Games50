Brick = Class{}
-- different colors made for when the bricks 'explode'
palette_colors = {
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}
--function to initialize bricks
function Brick:init(x,y)
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    self.inPlay = true
    --set constants for particles 
    self.pysystem = love.graphics.newParticleSystem(gTextures['particle'],64)
    self.pysystem:setParticleLifetime(0.5,1)
    self.pysystem:setLinearAcceleration(-15,0,15,80)
    self.pysystem:setAreaSpread('normal',10,10)
end

function Brick:hit()
    -- set the colors for the particles based on brick color
    self.pysystem:setColors(
        palette_colors[self.color].r,
        palette_colors[self.color].g,
        palette_colors[self.color].b,
        55 * (self.tier + 1),
        palette_colors[self.color].r,
        palette_colors[self.color].g,
        palette_colors[self.color].b,
        0
    )
    --emit the particles
    self.pysystem:emit(64)

    gSounds['brick_hit_two']:play()
    -- check if brick should be eliminated from play or sent down a tier
    if self.tier > 0 then 
        if self.color == 1 then 
            self.tier = self.tier -1
            self.color = 5
        else
            self.color = self.color -1
        end
    else   
        if self.color == 1 then 
            self.inPlay = false
        else
            self.color = self.color -1 
        end
    end
    if not self.inPlay then 
        gSounds['brick_hit_one']:stop()
        gSounds['brick_hit_one']:play()
    end
end

function Brick:update(dt)
    self.pysystem:update(dt)
end


function Brick:render()
    if self.inPlay == true then 
        love.graphics.draw(gTextures['main'],gFrames['bricks'][1+((self.color-1)*4) + self.tier],
        self.x,self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.pysystem,self.x+16,self.y+8)
end
