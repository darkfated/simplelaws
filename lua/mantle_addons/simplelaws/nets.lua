if SERVER then
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
            pl:ChatPrint('Это нельзя редактировать.')

            return
        end

        local len_text = string.len(text)

        if len_text < SimpleLawsConfig.min_len_law or len_text > SimpleLawsConfig.max_len_law then
            pl:ChatPrint('Разрешённая длинна от ' .. SimpleLawsConfig.min_len_law .. ' до ' .. SimpleLawsConfig.max_len_law)
            
            return
        end

        SimpleLaws_data[id] = text

        DarkRP.notifyAll(3, 4, 'Директор обновил устав #' .. id)

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
            pl:ChatPrint('Это нельзя удалять.')

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
            pl:ChatPrint('Разрешённая длинна от ' .. SimpleLawsConfig.min_len_law .. ' до ' .. SimpleLawsConfig.max_len_law)
            
            return
        end

        if table.Count(SimpleLaws_data) == SimpleLawsConfig.max_count then
            pl:ChatPrint('Больше уставов нельзя сделать!')

            return
        end

        SimpleLaws_data[#SimpleLaws_data + 1] = text

        DarkRP.notifyAll(3, 4, 'Директор создал устав. Ознакомтесь!')

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
else
    net.Receive('SimpleLaws-ToClient', function()
        local tbl = net.ReadTable()
    
        SimpleLaws_data = tbl
    end)
end
