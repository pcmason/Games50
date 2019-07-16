Pipe = Class{}
-- set local pipe image to be reused 
local PIPE_IMG = love.graphics.newImage('pipe.png')
--set speed of pipes 'passing'
PIPE_SCROLL = 60
--based on image details
PIPE_HGT = 288
PIPE_WD = 70

--initialize pipe 
function Pipe:init(orientation,y)
    -- give a slightly random distance between pipes generated
    self.x = VT_WIDTH + math.random(1000)
    -- y based on orientation
    self.y = y

    self.width = PIPE_IMG:getWidth()
    self.orientation = orientation 
end

function Pipe:update(dt)
    --self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    -- draw pipe on both the bottom and the top of the screen 
    love.graphics.draw(PIPE_IMG,self.x,
        (self.orientation == 'top' and self.y + PIPE_HGT or self.y),
        0,
        1,
        self.orientation == 'top' and -1 or 1)

end


