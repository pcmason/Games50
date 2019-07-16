Bird = Class{}
-- initialize gravity constant
local GRAVITY = 25
--initialize constructor
function Bird:update(dt)
    -- to make gravity gain speed over time multiply it by dt
    self.dy = self.dy + GRAVITY * dt
    -- update y
    self.y = self.y + self.dy
    -- begin jump if space or mouse was clicked
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then 
        -- update dy for jump
        self.dy = -5
        sounds['jump']:play()
    end
end


function Bird:init()
    -- initialize bird
    self.image = love.graphics.newImage('bird.png')
    self.height = self.image:getHeight()
    self.width = self.image:getWidth()
    -- set it in the center of the screen
    self.x = VT_WIDTH / 2 -(self.width/2)
    self.y = VT_HEIGHT /2 -(self.height/2)
    -- no initial speed
    self.dy = 0
end
-- render bird
function Bird:render()
    love.graphics.draw(self.image,self.x,self.y)
end
--use AABB collision detection to see if bird has collided with a pipe
function Bird:collide(pipe)
    if(self.x+2) + (self.width -4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WD then 
        if(self.y + 2)+ (self.height -4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HGT then
            return true
        end
    end
    return false
end
