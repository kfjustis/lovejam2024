local focus = {}

function focus:mousepressed(x, y, button, istouch)
    -- Switch on left click.
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
    love.graphics.clear(0, 0, 0, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Click to Start", G_GAMEHEIGHT / 2, G_GAMEHEIGHT / 2 - 8)

    -- Debug centering.
    --[[
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.line(0, G_GAMEHEIGHT/2, G_GAMEWIDTH, G_GAMEHEIGHT/2)
    love.graphics.line(G_GAMEWIDTH/2, 0, G_GAMEWIDTH/2, G_GAMEHEIGHT)
    ]]--

    Push:finish()
end

return focus