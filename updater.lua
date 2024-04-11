local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- func kickbp
local function kickbp()
    -- Get current time
    local response = HttpService:GetAsync("http://worldtimeapi.org/api/timezone/America/New_York")
    local timeData = HttpService:JSONDecode(response)
    local dateTime = timeData.datetime
    
    -- date and time w parse
    local year, month, day, hour, min = dateTime:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+)")
    if tonumber(month) == 4 and tonumber(day) == 12 and tonumber(hour) == 15 then
        return true
    else
        return false
    end
end

if kickbp() then
    -- kick player
        player:Kick("Rift has detected a game update, please wait for an all clear.")
        return
    end
end
