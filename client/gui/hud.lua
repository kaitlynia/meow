function drawHotbar()
	love.graphics.setColor({ 1, 1, 1, 0.9 })
	gui_batch:clear()
	local x = ScaledWindowWidth * 0.5 - (18 * 9) * 0.5
	local y = ScaledWindowHeight - 18 - 9
	for i = 0, Constants.MAX_HOTBAR_INDEX - 1 do
		local tex = QuadHotbarUnselected
		if i == player.hotbar_index - 1 then
			tex = QuadHotbarSelected
		end
		gui_batch:add(tex, x + i * 18, y)
	end
	love.graphics.draw(gui_batch)
	love.graphics.setColor({ 1, 1, 1, 1 })
end