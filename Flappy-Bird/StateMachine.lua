StateMachine = Class{}
-- create basic state machine functions for every state
function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}
    self.current = self.empty
end
-- function to change from one state to another
function StateMachine:change(stateName,enterParams)
    -- assert that the stateName is a defined state
    assert(self.states[stateName])
    --exit current state
    self.current:exit()
    --go into new state
    self.current = self.states[stateName]()
    -- keep necessary parameters (score or everything for the PauseState, etc)
    self.current:enter(enterParams)
end
-- defer update and render functions to the specific state classes
function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
