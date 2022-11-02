require "client.renderutil"
require "client.input"
require "client.gui.hud"

ShowDebug = true
InGame = true
local title_font = love.graphics.newFont("data/fonts/ProggyTinySZ.ttf", 64)

function drawGui()
	if InGame then
		drawHotbar()
	else
		drawMainMenu()
	end

	if ShowDebug then
		drawDebug()
	end
	love.graphics.pop()
	drawCursor()
end

function drawMainMenu()
	love.graphics.setFont(title_font)
	printBorder("Meow", ScaledWindowWidth / 2 - love.graphics.getFont():getWidth("Meow") / 2, 32, { 1.0 + math.sin(love.timer.getTime()) / 2.0, math.abs(math.cos(love.timer.getTime())), math.abs(math.sin(love.timer.getTime())) })
	love.graphics.setFont(GameFont)
	local w = 300

	love.graphics.setColor({ 0, 0, 0, 0.5 })
	love.graphics.rectangle("fill", ScaledWindowWidth / 2 - w / 2, 96, w, 200)
	love.graphics.setColor({ 1, 1, 1, 1 })

end

function drawCursor()
	gui_batch:clear()
	gui_batch:add(QuadCursor, MouseX - 1, MouseY - 1)
	love.graphics.draw(gui_batch)
	if ShowDebug then
		local worldpos = screenPosToWorldPos(MouseX, MouseY, camera)
		printBorder("pos:" .. math.floor(worldpos.x) .. ":" .. math.floor(worldpos.y), MouseX, MouseY + 16)
		printBorder("cam:" .. camera:getX() .. ":" .. camera:getY(), MouseX, MouseY + 32)
	end
end

function drawBackground()
	tilemap_batch:clear()
	love.graphics.setColor({ 1, 1, 1, 0.5 })
	for bx = -16, ScaledWindowWidth / 16 + 16 do
		for by = -16, ScaledWindowHeight / 16 + 16 do
			tilemap_batch:add(QuadBackgroundTile, bx * 16 - camera:getX() % 16, by * 16 - camera:getY() % 16, 0, 1, 1, 8, 8)
		end
	end
	love.graphics.draw(tilemap_batch)
	love.graphics.setColor({ 1, 1, 1, 1 })
end

function drawDebug()
	love.graphics.setColor({ 0, 0, 0, 0.5 })
	love.graphics.rectangle("fill", 8, 8, 128, ScaledWindowHeight - 16)
	love.graphics.setColor({ 1, 1, 1, 1 })
	if isWindowValidRatio() then
		printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 0, 1, 0 })
	else
		printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 1, 0, 0 })
	end
	printBorder("drawcalls: " .. love.graphics.getStats().drawcalls, 16, 16 * 2)
	printBorder("t-mem: " .. string.format("%.2f MB", love.graphics.getStats().texturememory / 1024 / 1024), 16, 16 * 3)
	printBorder("hotbar: " .. player.hotbar_index, 16, 16 * 4)
	local fps = string.format("FPS: %s", love.timer.getFPS())
	printBorder(fps, ScaledWindowWidth - love.graphics.getFont():getWidth(fps) - 2, 2)
	--local font = love.graphics.getFont()
	--printBorder("xD", window_width / 2 - font:getWidth("xD") / 2, window_height / 2 - font:getHeight() / 2, { 1.0 + math.sin(t) / 2.0, math.abs(math.cos(t)), math.abs(math.sin(t)) })
	local step = 48
	for i, v in pairs(Input) do
		step = step + 20
		printBorder(string.format("%-10s-%8s", i, tostring(v)), 16, step + 42)
	end

end
