ScoreState = Class{__includes = BaseState}
-- get the score from the play state
function ScoreState:enter(params)
    self.score = params.score
end
-- if user hits enter then begin another game
function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then 
        gStateMachine:change('countdown')
    end
end
-- render texts and medals if applicable
function ScoreState:render()
    if self.score >= 10 and self.score<= 19 then 
        medal = Medal('bronze_medal.png')
        medal:render()
    elseif self.score >= 20 and self.score <=29 then 
        medal = Medal('silver_medal.png')
        medal:render()
    elseif self.score >= 30 then 
        medal = Medal('gold_medal.png')
        medal:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof, You Lost :(',0,64,VT_WIDTH,'center')
    love.graphics.setFont(mediumeFont)
    love.graphics.printf('Score: ' .. tostring(self.score),0,100,VT_WIDTH,'center')
    love.graphics.printf('Press Enter to Play Again!', 0,160,VT_WIDTH,'center')
end