PlayState = Class{__includes =  BaseState}
-- utilized over init function to make pause state feasible
function PlayState:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pipepairs
    self.lastY = params.lastY 
    self.timer = params.timer 
    self.score = params.score
end

PIPE_SCROLL = 60
PIPE_WD = 70
PIPE_HGT = 288
BIRD_WD = 38 
BIRD_HGT = 24
-- change bird and pipePairs position accordingly
function PlayState:update(dt)
    self.bird:update(dt)

    self.timer = self.timer + dt
    -- generate a pipe pair every two seconds 
    -- make it random to create difference in pipe positions
    if self.timer > math.random(1.5,15) then 
        local y = math.max(-PIPE_HGT + 10,
            math.min(self.lastY + math.random(-20,20),VT_HEIGHT - 90 - PIPE_HGT))
        self.lastY = y
        table.insert(self.pipePairs,PipePair(y))
        self.timer = 0
    end
    -- if the user (bird) passes a pair of pipes then increment score by one
    for k,pair in pairs(self.pipePairs) do 
        if not pair.scored then 
            if pair.x + PIPE_WD < self.bird.x then 
                self.score = self.score  + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        pair:update(dt)
    end
    -- if pair of pipes has passed the boundary then delete them 
    for k, pair in pairs(self.pipePairs)do 
        if pair.remove then 
            table.remove(self.pipePairs,k)
        end
    end
    --if player hits a pipe then end play state, go to score state
    for k, pair in pairs(self.pipePairs) do 
        for l, pipe in pairs(pair.pipes) do 
            if self.bird:collide(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play() 
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end
    -- same is player hits the ground 
    if self.bird.y > VT_HEIGHT - 15 then 
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score',{
            score = self.score
        })
    end
    -- pause game and keep everything the same 
    if love.keyboard.wasPressed('p') == true then 
        gStateMachine:change('pause',{
            bird = self.bird,
            pipePairs = self.pipePairs,
            lastY = self.lastY,
            timer = self.timer,
            score = self.score
        })
    end
end
--render all the pipes and bird
function PlayState:render()
    for k,pair in pairs(self.pipePairs) do 
        pair:render()
    end
    -- render score in top left corner
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Score: ' .. tostring(self.score),8,8,VT_WIDTH)
    self.bird:render()
end

