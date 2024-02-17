local focus = {}

function focus:mousepressed(x, y, button, istouch)
    if button == 1 then
        Gamestate.switch(G_S_GAME)
     end
end

function focus:enter()
    print("INFO: Switched to scene: G_S_FOCUS.")
end

function focus:update(dt)
end

function focus:draw()
    Push:start()

    -- Black border bars and render region.
    Push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,0,1)

    love.graphics.print("Click to Start", 10, 10)

    Push:finish()
end

return focus