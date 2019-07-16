PauseState = Class{__includes = BaseState}
-- necessary to keep everything static durig pause state
function PauseState:enter(params)
    self.bird = params.bird
    self.pipepairs = params.pipePairs
    self.lastY = params.lastY
    self.timer = params.timer
    self.score = params.score
end
-- necessary to return static objects to the play state
function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then 
        gStateMachine:change('play',{
            bird = self.bird,
            pipepairs = self.pipepairs,
            lastY = self.lastY,
            timer = self.timer,
            score = self.score
        })
    end
end
-- render all of the objects the same as they were in the play state
function PauseState:render()
    for k,pair in pairs(self.pipepairs) do 
        pair:render()
    end
    self.bird:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Press p to Resume Game.',0,120,VT_WIDTH,'center')
end


