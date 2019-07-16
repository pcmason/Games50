PipePair = Class{}
-- make the gap heights slightly random throughout the game
local GAP_HGT = 80 + math.random(-40,40)
-- give a y that is determined by the pipes orientation
function PipePair:init(y)
    self.x = VT_WIDTH + 32
    self.y = y
    -- tables of pipes determined by key of 'upper' or 'lower'
    self.pipes = {
        ['upper'] = Pipe('top',self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HGT + GAP_HGT)
    }
    -- booleans to be used later
    self.remove = false

    self.scored = false
end

function PipePair:update(dt)
    -- if pipe is still on the screen then have it scroll at preset PIPE_SCROLL speed
    if self.x > -PIPE_WD then 
        self.x = self.x - PIPE_SCROLL * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    -- else remove the pipe for memeory management
    --overflow could occur if player made it far enought to generat too many pipes for memory storage
    else
        self.remove = true
    end
end
--defer pipepairs rendering to pipe's render function
function PipePair:render()
    for k, pipe in pairs(self.pipes) do 
        pipe:render()
    end
end