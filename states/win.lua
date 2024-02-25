local win = {}

function win:init()
end

function win:enter()
    print("INFO: Switched to scene: G_S_WIN.")
end

function win:leave()
end

function win:update(dt)
    if love.keyboard.isDown("backspace") then
        Gamestate.switch(G_S_GAME)
    end
end

function win:draw()
    Push:start()
    Push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,0,1)

    love.graphics.setColor(1, 1, 1, 1)

        local msg = "YOU WON!\n\n\n\n\n\nTry again? (Press BACKSPACE)"
        love.graphics.print(msg, 25, 25)
    Push:finish()
end

return win