local lose = {}

function lose:init()
end

function lose:enter()
    print("INFO: Switched to scene: G_S_LOSE.")
end

function lose:leave()
end

function lose:update(dt)
    if love.keyboard.isDown("backspace") then
        Gamestate.switch(G_S_GAME)
    end
end

function lose:draw()
    Push:start()
    Push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,0,1)

    love.graphics.setColor(1, 1, 1, 1)

        local msg = "Try again? (Press BACKSPACE)"
        love.graphics.print(msg, 25, 25)
    Push:finish()
end

return lose