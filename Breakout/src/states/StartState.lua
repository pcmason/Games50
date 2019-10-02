StartState = Class{__includes = BaseState}
--highlight used to highlight selected text
local highlight = 1
--set highscores
function StartState:enter(params)
    self.highScores = params.highScores
end


function StartState:update(dt)
    --change highlight with arrow movement
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then 
        highlight = highlight == 1 and 2 or 1
        gSounds['paddle_hit']:play()
    end
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then 
        gSounds['confirm']:play()
        -- change to paddle_select if they want to play
        if highlight == 1 then 
            gStateMachine:change('paddle_select',{
                highScores = self.highScores
            })
        -- else go to highscore state
        elseif highlight == 2 then  
            gStateMachine:change('high_score', {
                highScores = self.highScores
            })
        end
    end
    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end
end
--text rendered on plain image. 
function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('BREAKOUT',0,VT_HEIGHT / 3,VT_WIDTH,'center')
    love.graphics.setFont(gFonts['medium'])
    if highlight == 1 then 
        love.graphics.setColor(0,0,0,255)
    end
    love.graphics.printf('Play Game',0,VT_HEIGHT / 2 + 70 ,VT_WIDTH,'center' )

    love.graphics.setColor(255,255,255,255)

    if highlight == 2 then 
        love.graphics.setColor(0,0,0,255)
    end
    love.graphics.printf('High Scores', 0, VT_HEIGHT /2 + 90, VT_WIDTH,'center')

    love.graphics.setColor(255,255,255,255)

end