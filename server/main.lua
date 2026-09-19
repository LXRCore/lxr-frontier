--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Server: the idle kick, the player count for presence
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local F = LXRFrontier
local RES = GetCurrentResourceName()
local idle = {}   -- src → { pos, since, warned }
local washedAt = {}

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

AddEventHandler('playerDropped', function() idle[source] = nil washedAt[source] = nil end)

-- washing: the server takes the fee, checks the tub, and sets the need
RegisterNetEvent('lxr-frontier:server:washed', function(kind, tubId)
    local src = source
    if not Config.Wash.on then return end
    local W = Config.Wash[kind]
    if not W then return end
    if washedAt[src] and GetGameTimer() - washedAt[src] < (W.seconds or 10) * 1000 - 500 then return end
    washedAt[src] = GetGameTimer()
    local P = LXRCore.Functions.GetPlayer(src)
    if not P then return end
    if kind == 'bath' then
        local tub
        for _, t in ipairs(Config.Wash.tubs) do if t.id == tubId then tub = t end end
        local ped = GetPlayerPed(src)
        if not tub or ped == 0 or #(GetEntityCoords(ped) - tub.coords) > 4.0 then return end
        if (W.fee or 0) > 0 and not P.Functions.RemoveMoney(W.account or 'cash', W.fee, 'bath ' .. tub.id) then return LXRCore.Notify(src, Lang:t('error.no_money'), 'error') end
    end
    if GetResourceState('lxr-hud') == 'started' then
        if kind == 'bath' then exports['lxr-hud']:SetNeed(src, 'cleanliness', W.cleanliness) else exports['lxr-hud']:AddNeed(src, 'cleanliness', W.cleanliness) end
    end
    TriggerClientEvent('lxr-frontier:client:washed', src)
    LXRCore.Emit('lxr:frontier:washed', nil, src, kind)
end)
CreateThread(function() if Config.Debug.printBanner then print(('^1[lxr-frontier]^7 v%s — %s'):format(GetResourceMetadata(RES, 'version', 0), table.concat(F.Modules(), ', '))) end end)
exports('IdleSeconds', function(src) local e = idle[src] return e and (os.time() - e.since) or 0 end)
