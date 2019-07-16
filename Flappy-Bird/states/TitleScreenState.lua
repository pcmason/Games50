TitleScreenState = Class{__includes = BaseState}
-- first state that will be introduced upon running game
-- if enter is pressed then go into countdown state
function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end
-- introduction text on the title screen 
function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird',0,64,VT_WIDTH,'center')
    love.graphics.setFont(mediumeFont)
    love.graphics.printf('Press Enter',0,100,VT_WIDTH,'center')
end
