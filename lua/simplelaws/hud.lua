local scrw, scrh = ScrW(), ScrH()
local color_gray = Color(220, 220, 220)

hook.Add('HUDPaint', 'SimpleLaws.Hud', function()
    if g_SpawnMenu:IsVisible() then
        return
    end

    local maxWidth = 180
    local lineHeight = 20
    local yPos = 20
    local totalHeight = 0
    local lawSpacing = 5
    
    for i, law in ipairs(SimpleLaws_data) do
        local wrappedText = DarkRP.textWrap(i .. '. ' .. law, 'Fated.17', maxWidth - 16)
        local lines = string.Explode('\n', wrappedText)

        totalHeight = totalHeight + #lines * lineHeight + lawSpacing
    end
    
    draw.RoundedBox(16, scrw - maxWidth - 14, 10, maxWidth + 6, totalHeight + 14, Mantle.color.background_alpha)
    
    for i, law in ipairs(SimpleLaws_data) do
        local wrappedText = DarkRP.textWrap(i .. '. ' .. law, 'Fated.17', maxWidth - 16)
        local lines = string.Explode('\n', wrappedText)

        for j, line in ipairs(lines) do
            draw.SimpleText(line, 'Fated.17', scrw - maxWidth - 2, yPos, color_gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            yPos = yPos + lineHeight
    
            if j == #lines then
                yPos = yPos + lawSpacing
            end
        end
    end
end)
