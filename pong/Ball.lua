Ball = Class {}
--constructor
function Ball:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50,50)
end
--reset function
function Ball:reset()
    self.x = VT_WIDTH /2 -2
    self.y = VT_HEIGHT /2 -2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50,50)
end
--update the balls speed
function Ball:update(dt)
    self.x = self.x + self.dx *dt
    self.y = self.y + self.dy *dt
end
--creat teh ball
function Ball:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end
--function for ball & paddle collision
--uses AABB collision detection
function Ball:collide(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 
    return true
end

function Ball:collideball(ball)
    if self.x > ball.x + ball.width or ball.x > self.x + self.width then
        return false
    end
    if self.y > ball.y + ball.height or ball.y > self.x + self.width then 
        return false
    end
    return true
end

