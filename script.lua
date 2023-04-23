
local Players = game:GetService("Players")
local PlayerM = {
    TotalPlayers = {},
    CurrentPlayers = {},
    CountedPlayers = 0,

    OnPlayerRejoin = {},
    OnPlayerFirstJoin = {},
    OnPlayerJoin = {},
    OnPlayerLeft = {},
    SelectedPlayer = nil,
    Prefix = ":",
    LastPlayer = nil,
    SpecialPlayers = nil,
    SpecialName = "Special",
    Started = false,
    OnSpecialPlayerJoin = {},
    OnSpecialPlayerFound = {}
}
local lp = Players.LocalPlayer
function PlayerM:Start()
    PlayerM.Started = true
end

function PlayerM.OnPlayerJoin:Connect(funct)
    if PlayerM.Started == false then
        repeat wait() until PlayerM.Started == true
    end
    local t = PlayerM.OnPlayerJoin
    local tab = {}
    local index = #t
    table.insert(t, funct)
    local disconnect
    function tab:Disconnect()
        for i,v in pairs(t) do
            if v[1] == funct then
                v = {}
                table.remove(t, i)
            end
        end
        tab = nil
    end
    return tab
end
function PlayerM.OnSpecialPlayerJoin:Connect(funct)
    if PlayerM.Started == false then
        repeat wait() until PlayerM.Started == true
    end
    local t = PlayerM.OnSpecialPlayerJoin
    local tab = {}
    local index = #t
    table.insert(t, funct)
    local disconnect
    function tab:Disconnect()
        for i,v in pairs(t) do
            if v[1] == funct then
                v = {}
                table.remove(t, i)
            end
        end
        tab = nil
    end
    return tab
end
function PlayerM.OnSpecialPlayerFound:Connect(funct)
    if PlayerM.Started == false then
        repeat wait() until PlayerM.Started == true
    end
    local t = PlayerM.OnSpecialPlayerFound
    local tab = {}
    local index = #t
    table.insert(t, funct)
    local disconnect
    function tab:Disconnect()
        for i,v in pairs(t) do
            if v[1] == funct then
                v = {}
                table.remove(t, i)
            end
        end
        tab = nil
    end
    return tab
end
function PlayerM.OnPlayerRejoin:Connect(funct)
    if PlayerM.Started == false then
        repeat wait() until PlayerM.Started == true
    end
    local t = PlayerM.OnPlayerRejoin
    local tab = {}
    local index = #t
    table.insert(t, funct)
    local disconnect
    function tab:Disconnect()
        for i,v in pairs(t) do
            if v[1] == funct then
                v = {}
                table.remove(t, i)
            end
        end
        tab = nil
    end
    return tab
end
function PlayerM.OnPlayerFirstJoin:Connect(funct)
    if PlayerM.Started == false then
        repeat wait() until PlayerM.Started == true
    end
    local t = PlayerM.OnPlayerFirstJoin
    local tab = {}
    local index = #t
    table.insert(t, funct)
    local disconnect
    function tab:Disconnect()
        for i,v in pairs(t) do
            if v[1] == funct then
                v = {}
                table.remove(t, i)
            end
        end
        tab = nil
    end
    return tab
end
function PlayerM.OnPlayerLeft:Connect(funct)
    if PlayerM.Started == false then
        repeat wait() until PlayerM.Started == true
    end
    local t = PlayerM.OnPlayerLeft
    local tab = {}
    local index = #t
    table.insert(t, funct)
    local disconnect
    function tab:Disconnect()
        for i,v in pairs(t) do
            if v[1] == funct then
                v = {}
                table.remove(t, i)
            end
        end
        tab = nil
    end
    return tab
end
function PlayerFromID(plr)
    local r = nil
	for _,v in pairs(Players:GetPlayers()) do
		if v.UserId == plr.UserId then
			r = plr
		end
	end
	return r
end
--{UserId = player.UserId, Number = PlayerM.CountedPlayers, Player = Player}
function PlayerFromNumber(num)
    for _,ids in pairs(PlayerM.TotalPlayers) do
        if ids.Number == num then
            return ids.Player
        end
    end
end
function PlayerM:IsSpecial(plr1)
    if PlayerM.SpecialPlayers then
        for _,plr in pairs(PlayerM.SpecialPlayers) do
            if plr.UserId == plr1.UserId then
                return true
            end
        end
        return false
    end
   
end
function NumberFromPlayer(plr)
    for _,ids in pairs(PlayerM.TotalPlayers) do
        if plr.UserId == ids.UserId then
            return ids.Number
        end
    end
end
function PlayerM:GetPlayer(str)
    if str ~= "" and #str >= #PlayerM.Prefix and string.sub(str, 0,#PlayerM.Prefix) == PlayerM.Prefix then
        
        str = string.sub(str,(#PlayerM.Prefix+1),#str)
        if str == "s" then
            PlayerM.LastPlayer = PlayerM.SelectedPlayer
            return PlayerM.SelectedPlayer
        end
        if str == "me" then
            PlayerM.LastPlayer = lp
            return lp
        end
        if str == "l" or str == "last" then
            return PlayerM.LastPlayer
        end
        if str == "r" or str == "random" then
            local AllPlayers = Players:GetPlayers()
            if AllPlayers[1] then
                local plr = AllPlayers[math.random(1,#AllPlayers)]
                PlayerM.LastPlayer = plr
                return plr
            end
        end
        if tonumber(str) then
            local plr = PlayerFromNumber(tonumber(str))
            PlayerM.LastPlayer = plr
            return plr
        end
        if str:sub(0,1) == "[" and str:sub(#str, #str) == "]" then
            str = str:sub(2,#str-1)
            for _,plr in pairs(Players:GetPlayers()) do
                if plr.Name == "str" then
                    return plr
                end
            end
        end
    else
        local matches= {}
        for _, player in ipairs (Players:GetPlayers()) do
            if player ~= lp then
                if player.Name:lower():match(str:lower()) then
                    table.insert(matches, player)
                end
            end
        end
        if #matches== 1 then
            PlayerM.LastPlayer = matches[1]
            return matches[1]
        else
            return nil
        end
    end

    return nil
end
for i,player in pairs(Players:GetPlayers()) do
    PlayerM.CountedPlayers = PlayerM.CountedPlayers+1
    table.insert(PlayerM.TotalPlayers, {UserId = player.UserId, Number = PlayerM.CountedPlayers, Player = player})

    task.spawn(function()
        if PlayerM.Started == false then
            repeat wait() until PlayerM.Started == true
        end
        
        for _,funct in pairs(PlayerM.OnPlayerFirstJoin) do
            local sucess, err = pcall(funct,player, true)
            -- if err then print(err) end
        end
        if PlayerM:IsSpecial(player) then
            for _,funct in pairs(PlayerM.OnSpecialPlayerFound) do
                local sucess, err = pcall(funct,player)
                -- if err then print(err) end
            end
        end
        
    end)
end
function PlayerM:GetName(plr)
    local ds = plr.DisplayName
    local un = plr.Name
    if ds == un then
        ds = ""
    else
        ds = ds.." "
    end
    local num = NumberFromPlayer(plr)
    return "[#"..num.."]: "..ds.."@"..un
end
Players.PlayerAdded:connect(function(player)

    local found = false
    local tab = nil
    for _,f in pairs(PlayerM.TotalPlayers) do
        if f.UserId == player.UserId then
            found = true
            tab = f
        end
    end
    if found == false then
       
        PlayerM.CountedPlayers = PlayerM.CountedPlayers+1
        table.insert(PlayerM.TotalPlayers, {UserId = player.UserId, Number = PlayerM.CountedPlayers, Player = player})
        for _,funct in pairs(PlayerM.OnPlayerFirstJoin) do
            local sucess, err = pcall(funct,player, false)
            -- if err then print(err) end
        end
    elseif found == true then
        tab.Player = player
        for _,funct in pairs(PlayerM.OnPlayerRejoin) do
            local sucess, err = pcall(funct,player, false)
            -- if err then print(err) end
        end
    end
    task.spawn(function()
        repeat wait() until PlayerM.Started == true
        if PlayerM:IsSpecial(player) then
            for _,funct in pairs(PlayerM.OnSpecialPlayerJoin) do
                local sucess, err = pcall(funct,player)
                -- if err then print(err) end
            end
        end
    end)
    -- Joined
    for _,funct in pairs(PlayerM.OnPlayerJoin) do
        local sucess, err = pcall(funct,player, false)
        -- if err then print(err) end
    end
    
end)

Players.PlayerRemoving:connect(function(player)
    for _,funct in pairs(PlayerM.OnPlayerLeft) do
        local sucess, err = pcall(funct,player)
        -- if err then print(err) end
    end
end)


function PlayerM:SetSpecialPlayerTable(tab)
    if type(tab) == "table" then
        PlayerM.SpecialPlayers = tab
    elseif tab == nil then
        PlayerM.SpecialPlayers = nil
    end
end
function PlayerM:SetSpecialName(str)
    if tostring(str) then
        PlayerM.SpecialName = str
    end
end

function PlayerM:AddSpecialPlayer(plr)
    if type(PlayerM.SpecialPlayers) == "table" then
        table.insert(PlayerM.SpecialPlayers, plr)
    end
end



return PlayerM
