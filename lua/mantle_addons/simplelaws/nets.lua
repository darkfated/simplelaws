if SERVER then
    local color_error = Color(255, 80, 80)

    util.AddNetworkString('SimpleLaws-ToClient')
    util.AddNetworkString('SimpleLaws-Update')
    util.AddNetworkString('SimpleLaws-Delete')
    util.AddNetworkString('SimpleLaws-Create')
    util.AddNetworkString('SimpleLaws-Reset')

    hook.Add('PostGamemodeLoaded', 'SimpleLaws.CopyDarkRP', function()
        SimpleLaws_data = table.Copy(GAMEMODE.Config.DefaultLaws)
    end)

    local function UpdateForPlayers()
        net.Start('SimpleLaws-ToClient')
            net.WriteTable(SimpleLaws_data)
        net.Broadcast()
    end
    
    hook.Add('PlayerInitialSpawn', 'SimpleLaws.Players', function(pl)
        UpdateForPlayers()
    end)

    net.Receive('SimpleLaws-Update', function(_, pl)
        local id = net.ReadUInt(4)
        local text = net.ReadString()

        if !id or !text then
            return
        end

        if pl:getJobTable().command != SimpleLawsConfig.job_access then
            DarkRP.notify(pl, 1, 3, 'Нету доступа!')

            return
        end

        if id <= SimpleLawsConfig.default_law_count then
            Mantle.notify(pl, color_error, 'Законы', 'Это нельзя редактировать.')
            return
        end

        local len_text = string.len(text)

        if len_text < SimpleLawsConfig.min_len_law or len_text > SimpleLawsConfig.max_len_law then
            Mantle.notify(pl, color_error, 'Законы', 'Разрешённая длинна от ' .. SimpleLawsConfig.min_len_law .. ' до ' .. SimpleLawsConfig.max_len_law)
            return
        end

        SimpleLaws_data[id] = text

        DarkRP.notifyAll(3, 4, 'Мэр обновил закон #' .. id)

        UpdateForPlayers()
    end)

    net.Receive('SimpleLaws-Delete', function(_, pl)
        local id = net.ReadUInt(4)

        if !id then
            return
        end

        if pl:getJobTable().command != SimpleLawsConfig.job_access then
            DarkRP.notify(pl, 1, 3, 'Нету доступа!')

            return
        end

        if id <= SimpleLawsConfig.default_law_count then
            Mantle.notify(pl, color_error, 'Законы', 'Стандартный закон невозможно удалить.')
            return
        end

        SimpleLaws_data[id] = nil 

        UpdateForPlayers()
    end)

    net.Receive('SimpleLaws-Create', function(_, pl)
        local text = net.ReadString()

        if !text then
            return
        end

        if pl:getJobTable().command != SimpleLawsConfig.job_access then
            DarkRP.notify(pl, 1, 3, 'Нету доступа!')

            return
        end

        local len_text = string.len(text)

        if len_text < SimpleLawsConfig.min_len_law or len_text > SimpleLawsConfig.max_len_law then
            Mantle.notify(pl, color_error, 'Законы', 'Разрешённая длинна от ' .. SimpleLawsConfig.min_len_law .. ' до ' .. SimpleLawsConfig.max_len_law)
            return
        end

        if table.Count(SimpleLaws_data) == SimpleLawsConfig.max_count then
            Mantle.notify(pl, color_error, 'Законы', 'Достигнуто максимальное кол-во законов!')
            return
        end

        SimpleLaws_data[#SimpleLaws_data + 1] = text

        DarkRP.notifyAll(3, 4, 'Мэр создал закон. Ознакомьтесь!')

        UpdateForPlayers()
    end)

    net.Receive('SimpleLaws-Reset', function(_, pl)
        if pl:getJobTable().command != SimpleLawsConfig.job_access then
            DarkRP.notify(pl, 1, 3, 'Нету доступа!')

            return
        end

        SimpleLaws_data = table.Copy(GAMEMODE.Config.DefaultLaws)

        UpdateForPlayers()
    end)

    local chatCommands = {
        ['/laws'] = true,
        ['/законы'] = true,
        ['!laws'] = true,
        ['!законы'] = true
    }
    hook.Add('PlayerSay', 'SimpleLaws.ChatCommand', function(pl, text)
        if chatCommands[text:lower()] then
            pl:ConCommand('simplelaws_open')
            return ''
        end
    end)
else
    net.Receive('SimpleLaws-ToClient', function()
        local tbl = net.ReadTable()
    
        SimpleLaws_data = tbl
    end)
end
