Ball = Class{}
--function to initialize the ball
function Ball:init(skin)
    self.width = 8
    self.height = 8

    self.dy = 0
    self.dx = 0
    
    self.skin = skin
end
--boolean to check if ball has collided with anything
function Ball:collide(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end
    if self.y > target.y + target.height or target.y > self.y + self.height then 
        return false
    end
    return true
end
--function to reset ball either at start of play or after death
function Ball:reset()
    self.x = VT_WIDTH /2 - 2
    self.y = VT_HEIGHT/2 -2  
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    --update balls speed
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    --multiple if statements to ensure ball does not exceed boundary
    if self.x <= 0 and self.y < VT_HEIGHT  then 
        self.dx = -self.dx
        self.x = 0
        gSounds['wall_hit']:play()
    end

    if self.x >= VT_WIDTH - 8 and self.y < VT_HEIGHT then 
        self.dx = -self.dx
        self.x = VT_WIDTH - 8
        gSounds['wall_hit']:play()
    end

    if self.y <= 0 and self.y < VT_HEIGHT then 
        self.dy = -self.dy
        self.y = 0
        gSounds['wall_hit']:play()
    end
end

function Ball:render()
    love.graphics.draw(gTextures['main'],gFrames['balls'][self.skin],self.x,self.y)
end