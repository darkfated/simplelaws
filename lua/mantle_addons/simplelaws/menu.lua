local function Create()
    local menuLaws = vgui.Create('MantleFrame')
    menuLaws:SetSize(700, 500)
    menuLaws:Center()
    menuLaws:MakePopup()
    menuLaws:SetCenterTitle('Настройки')
    menuLaws:SetTitle('SimpleLaws')

    local sp = vgui.Create('MantleScrollPanel', menuLaws)
    sp:Dock(FILL)

    local function CreateLaws()
        sp:Clear()

        for i, law in ipairs(SimpleLaws_data) do
            local panelLaw = vgui.Create('DPanel', sp)
            panelLaw:Dock(TOP)
            panelLaw:DockMargin(0, 0, 0, 6)
            panelLaw:SetTall(50)
            panelLaw.Paint = function(_, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Mantle.color.panel[2])
                draw.SimpleText(i .. '.', 'Fated.20b', 8, 4, Mantle.color.gray)
                draw.SimpleText(SimpleLaws_data[i], 'Fated.17', 18, h - 7, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
            end

            panelLaw.btnEdit = vgui.Create('MantleBtn', panelLaw)
            panelLaw.btnEdit:Dock(RIGHT)
            panelLaw.btnEdit:DockMargin(4, 4, 4, 4)
            panelLaw.btnEdit:SetWide(80)
            panelLaw.btnEdit:SetTxt('Изменить')
            panelLaw.btnEdit.DoClick = function()
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

    menuLaws.bottomPanel = vgui.Create('DPanel', menuLaws)
    menuLaws.bottomPanel:Dock(BOTTOM)
    menuLaws.bottomPanel:DockMargin(0, 6, 0, 0)
    menuLaws.bottomPanel:SetTall(30)
    menuLaws.bottomPanel.Paint = nil

    menuLaws.bottomPanel.btnCreate = vgui.Create('MantleBtn', menuLaws.bottomPanel)
    menuLaws.bottomPanel.btnCreate:Dock(LEFT)
    menuLaws.bottomPanel.btnCreate:SetWide((menuLaws:GetWide() - 12) * 0.5 - 3)
    menuLaws.bottomPanel.btnCreate:SetTxt('Добавить')
    menuLaws.bottomPanel.btnCreate.DoClick = function()
        Mantle.ui.text_box('Добавить', 'Какое содержание желаете?', function(s)
            net.Start('SimpleLaws-Create')
                net.WriteString(s)
            net.SendToServer()

            timer.Simple(0.5, function()
                CreateLaws()
            end)
        end)
    end

    menuLaws.bottomPanel.btnReset = vgui.Create('MantleBtn', menuLaws.bottomPanel)
    menuLaws.bottomPanel.btnReset:Dock(FILL)
    menuLaws.bottomPanel.btnReset:DockMargin(3, 0, 0, 0)
    menuLaws.bottomPanel.btnReset:SetTxt('Сбросить закон')
    menuLaws.bottomPanel.btnReset.DoClick = function()
        net.Start('SimpleLaws-Reset')
        net.SendToServer()

        timer.Simple(0.5, function()
            CreateLaws()
        end)
    end
end

concommand.Add('simplelaws_open', Create)
