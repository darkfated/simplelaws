local color_btn_delete = Color(197, 78, 78)
local color_btn_edit = Color(187, 179, 68)

local function Create()
    local menuLaws = vgui.Create('MantleFrame')
    menuLaws:SetSize(600, 420)
    menuLaws:Center()
    menuLaws:MakePopup()
    menuLaws:SetTitle('')
    menuLaws:SetCenterTitle('Управление законами')
    menuLaws:ShowAnimation()

    local sp = vgui.Create('MantleScrollPanel', menuLaws)
    sp:Dock(FILL)

    local function CreateLaws()
        sp:Clear()
        for i, law in ipairs(SimpleLaws_data) do
            local panelLaw = vgui.Create('DPanel', sp)
            panelLaw:Dock(TOP)
            panelLaw:DockMargin(0, 0, 0, 6)
            panelLaw:SetTall(40)
            panelLaw.Paint = function(_, w, h)
                draw.RoundedBox(6, 0, 0, w, h, Mantle.color.panel[2])
                draw.SimpleText(i .. '.', 'Fated.18', 12, h/2, Mantle.color.gray, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(SimpleLaws_data[i], 'Fated.16', 32, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local btnEdit = vgui.Create('MantleBtn', panelLaw)
            btnEdit:Dock(RIGHT)
            btnEdit:DockMargin(4, 4, 4, 4)
            btnEdit:SetWide(32)
            btnEdit:SetIcon('icon16/pencil.png', 16)
            btnEdit:SetTxt('')
            btnEdit:SetColorHover(color_btn_edit)
            btnEdit.DoClick = function()
                Mantle.ui.text_box('Редактировать', 'Введите новый текст закона:', function(s)
                    net.Start('SimpleLaws-Update')
                        net.WriteUInt(i, 4)
                        net.WriteString(s)
                    net.SendToServer()
                    timer.Simple(0.3, CreateLaws)
                end)
            end

            local btnDel = vgui.Create('MantleBtn', panelLaw)
            btnDel:Dock(RIGHT)
            btnDel:DockMargin(0, 4, 4, 4)
            btnDel:SetWide(32)
            btnDel:SetIcon('icon16/delete.png', 16)
            btnDel:SetTxt('')
            btnDel:SetColorHover(color_btn_delete)
            btnDel.DoClick = function()
                net.Start('SimpleLaws-Delete')
                    net.WriteUInt(i, 4)
                net.SendToServer()
                timer.Simple(0.3, CreateLaws)
            end
        end
    end

    CreateLaws()

    local bottomPanel = vgui.Create('DPanel', menuLaws)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:DockMargin(6, 6, 6, 6)
    bottomPanel:SetTall(36)
    bottomPanel.Paint = nil

    local btnCreate = vgui.Create('MantleBtn', bottomPanel)
    btnCreate:Dock(LEFT)
    btnCreate:SetWide(140)
    btnCreate:SetTxt('Добавить закон')
    btnCreate.DoClick = function()
        Mantle.ui.text_box('Добавить закон', 'Введите текст закона:', function(s)
            net.Start('SimpleLaws-Create')
                net.WriteString(s)
            net.SendToServer()
            timer.Simple(0.3, CreateLaws)
        end)
    end

    local btnReset = vgui.Create('MantleBtn', bottomPanel)
    btnReset:Dock(RIGHT)
    btnReset:SetWide(140)
    btnReset:SetTxt('Сбросить всё')
    btnReset.DoClick = function()
        net.Start('SimpleLaws-Reset')
        net.SendToServer()
        timer.Simple(0.3, CreateLaws)
    end
end

concommand.Add('simplelaws_open', Create)
