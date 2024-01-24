local function Create()
    local menu = vgui.Create('DFrame')
    Mantle.ui.frame(menu, 'SimpleLaws', 700, 500, true)
    menu:Center()
    menu:MakePopup()
    menu.center_title = 'Настройки'

    menu.sp = vgui.Create('DScrollPanel', menu)
    Mantle.ui.sp(menu.sp)
    menu.sp:Dock(FILL)

    local function CreateLaws()
        menu.sp:Clear()

        for i, law in ipairs(SimpleLaws_data) do
            local panel_law = vgui.Create('DPanel', menu.sp)
            panel_law:Dock(TOP)
            panel_law:DockMargin(0, 0, 0, 6)
            panel_law:SetTall(50)
            panel_law.Paint = function(_, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Mantle.color.panel[2])
                draw.SimpleText(i .. '.', 'Fated.20', 8, 4, Mantle.color.gray)
                draw.SimpleText(SimpleLaws_data[i], 'Fated.17', 18, h - 7, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            end

            panel_law.btn_edit = vgui.Create('DButton', panel_law)
            Mantle.ui.btn(panel_law.btn_edit)
            panel_law.btn_edit:Dock(RIGHT)
            panel_law.btn_edit:DockMargin(4, 4, 4, 4)
            panel_law.btn_edit:SetWide(80)
            panel_law.btn_edit:SetText('Изменить')
            panel_law.btn_edit.DoClick = function()
                local DM = Mantle.ui.derma_menu()
                DM:AddOption('Изменить содержимое', function()
                    Mantle.ui.text_box('Изменить', 'Какой текст желаете поставить?', function(s)
                        net.Start('SimpleLaws-Update')
                            net.WriteUInt(i, 4)
                            net.WriteString(s)
                        net.SendToServer()

                        timer.Simple(0.5, function()
                            CreateLaws()
                        end)
                    end)
                end, 'icon16/plugin_edit.png')
                DM:AddOption('Удалить', function()
                    net.Start('SimpleLaws-Delete')
                        net.WriteUInt(i, 4)
                    net.SendToServer()

                    timer.Simple(0.5, function()
                        CreateLaws()
                    end)
                end, 'icon16/delete.png')
            end
        end
    end

    CreateLaws()

    menu.bottom_panel = vgui.Create('DPanel', menu)
    menu.bottom_panel:Dock(BOTTOM)
    menu.bottom_panel:DockMargin(0, 6, 0, 0)
    menu.bottom_panel:SetTall(30)
    menu.bottom_panel.Paint = nil

    menu.bottom_panel.btn_create = vgui.Create('DButton', menu.bottom_panel)
    Mantle.ui.btn(menu.bottom_panel.btn_create)
    menu.bottom_panel.btn_create:Dock(LEFT)
    menu.bottom_panel.btn_create:SetWide((menu:GetWide() - 12) * 0.5 - 3)
    menu.bottom_panel.btn_create:SetText('Добавить')
    menu.bottom_panel.btn_create.DoClick = function()
        Mantle.ui.text_box('Добавить', 'Какое содержание желаете?', function(s)
            net.Start('SimpleLaws-Create')
                net.WriteString(s)
            net.SendToServer()

            timer.Simple(0.5, function()
                CreateLaws()
            end)
        end)
    end

    menu.bottom_panel.btn_reset = vgui.Create('DButton', menu.bottom_panel)
    Mantle.ui.btn(menu.bottom_panel.btn_reset)
    menu.bottom_panel.btn_reset:Dock(FILL)
    menu.bottom_panel.btn_reset:DockMargin(3, 0, 0, 0)

    menu.bottom_panel.btn_reset:SetText('Сбросить устав')
    menu.bottom_panel.btn_reset.DoClick = function()
        net.Start('SimpleLaws-Reset')
        net.SendToServer()

        timer.Simple(0.5, function()
            CreateLaws()
        end)
    end
end

concommand.Add('simplelaws_open', Create)
