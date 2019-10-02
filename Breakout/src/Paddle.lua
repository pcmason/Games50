Paddle = Class{}


--function to initialize paddles
function Paddle:init(skin)
    self.x = VT_WIDTH / 2 - 32
    self.y = VT_HEIGHT - 32
    self.small = false
    self.larger = false
    self.dx = 0
    self.width = 64
    self.height = 16

    self.skin = skin
    self.size = 2
end

function Paddle:update(dt)
    --changing the size of the paddle determined on the two booleans
    if self.larger == true and self.small == true then 
        self.size = 2
        self.width = 64
    elseif self.larger == true and self.small == false then 
        self.size = 3
        self.width = 96
    elseif self.larger == false and self.small == true then 
        self.size = 1 
        self.width = 32
    end
    --keyboard commands to move paddle
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SP
    elseif love.keyboard.isDown('right') then 
        self.dx = PADDLE_SP
    else
        self.dx = 0
    end
    --boundary so paddle never exceeds screen limits
    if self.dx < 0 then 
        self.x = math.max(0,self.x + self.dx *dt)
    else 
        self.x = math.min(VT_WIDTH - self.width,self.x + self.dx * dt)
    end
end

function Paddle:render()
    paddle_size = self.size
    love.graphics.draw(gTextures['main'],gFrames['paddles'][self.size + 4 * (self.skin - 1)],
    self.x,self.y)
end




