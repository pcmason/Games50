Powerup = Class{}
--initialize powerup
function Powerup:init()
    --initialized off-screen to be out of sight for player
    self.x = 100
    self.y = 100
    self.width =16
    self.height =24
    --powerup can be inplay every 1 out of 3 levels
    if math.random(3) == 2 then 
        self.inplay = true
    else
        self.inplay = false
    end
end

function Powerup:hit()
    self.inplay = false
    gSounds['recover']:play()
end

function Powerup:render()
    if self.inplay == true then 
        love.graphics.draw(gTextures['main'],gFrames['powerup'][7],self.x,self.y)
    end
end


