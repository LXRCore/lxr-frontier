--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Server: the idle kick, the player count for presence
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local F = LXRFrontier
local RES = GetCurrentResourceName()
local idle = {}   -- src → { pos, since, warned }

if Config.AFK.on then
    CreateThread(function()
        while true do
            Wait(Config.AFK.sampleSeconds * 1000)
            local now = os.time()
            for _, id in ipairs(GetPlayers()) do
                local src = tonumber(id)
                local ped = GetPlayerPed(src)
                if ped and ped ~= 0 and not LXRCore.Perms.Has(src, Config.AFK.exemptGroup) then
                    local pos = GetEntityCoords(ped)
                    local e = idle[src]
                    if not e or F.Moved(e.pos, pos) then idle[src] = { pos = { x = pos.x, y = pos.y, z = pos.z }, since = now, warned = false }
                    else
                        local verdict = F.Idle(now - e.since)
                        if verdict == 'kick' then LXRCore.Functions.Kick(src, Lang:t('afk.kicked', { minutes = Config.AFK.minutes })) idle[src] = nil
                        elseif verdict == 'warn' and not e.warned then e.warned = true LXRCore.Notify(src, Lang:t('afk.warn', { minutes = Config.AFK.minutes - Config.AFK.warnAtMinutes }), 'warning', 10000) end
                    end
                end
            end
        end
    end)
end

CreateThread(function()
    while true do
        GlobalState['lxr:players'] = #GetPlayers()
        Wait(30000)
    end
end)

AddEventHandler('playerDropped', function() idle[source] = nil end)
CreateThread(function() if Config.Debug.printBanner then print(('^1[lxr-frontier]^7 v%s — %s'):format(GetResourceMetadata(RES, 'version', 0), table.concat(F.Modules(), ', '))) end end)
exports('IdleSeconds', function(src) local e = idle[src] return e and (os.time() - e.since) or 0 end)
