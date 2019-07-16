CountdownState = Class{__includes = BaseState}
-- 1 second is a little long for a countdown
CD_TIME = .75
-- set the count to 3 and timer to 0
function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    -- if timer passes the countdown timer then 
    if self.timer > CD_TIME then 
        --reset timer
        self.timer = self.timer % CD_TIME
        --decrement the counter
        self.count = self.count - 1
        -- once countdown is 0 then go into play state
        if self.count == 0 then 
            -- parameters necessary to initialize pause state
            gStateMachine:change('play',{
                bird = Bird(),
                pipepairs = {},
                lastY = -PIPE_HGT + math.random(80) + 20,
                timer = 0,
                score = 0
            })
        end
    end
end
-- render the huge font of the countdown 
function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count),0,120,VT_WIDTH,'center')
end
