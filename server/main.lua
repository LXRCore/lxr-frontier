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

-- searching the dead: the body must exist, be dead, be near, and not have been searched
local looted = {}   -- netId → os.time()
RegisterNetEvent('lxr-frontier:server:loot', function(netId)
    local src = source
    if not Config.Loot.on then return end
    netId = tonumber(netId) or 0
    local ent = NetworkGetEntityFromNetworkId(netId)
    local P = LXRCore.Functions.GetPlayer(src)
    if not P or not ent or ent == 0 or not DoesEntityExist(ent) or IsPedAPlayer(ent) or GetEntityHealth(ent) > 0 then return end
    local ped = GetPlayerPed(src)
    if ped == 0 or #(GetEntityCoords(ped) - GetEntityCoords(ent)) > Config.Loot.distance + 1.5 then return end
    if looted[netId] and os.time() - looted[netId] < (Config.Loot.rememberMinutes or 30) * 60 then return LXRCore.Notify(src, Lang:t('info.already_searched'), 'inform') end
    looted[netId] = os.time()
    local got = {}
    local L = Config.Loot
    if math.random() < (L.cash.chance or 0) then
        local cents = math.random(L.cash.min or 5, L.cash.max or 150)
        P.Functions.AddMoney('cash', cents / 100, 'searched a body')
        got[#got + 1] = ('$%.2f'):format(cents / 100)
    end
    for _, e in ipairs(L.items or {}) do
        if LXRShared.Items[e.item] and math.random() < (e.chance or 0) then
            local n = math.random(e.min or 1, e.max or 1)
            if P.Functions.AddItem(e.item, n, nil, nil, 'searched a body') then got[#got + 1] = ('%dx %s'):format(n, LXRShared.Items[e.item].label) end
        end
    end
    LXRCore.Notify(src, #got > 0 and Lang:t('info.found', { what = table.concat(got, ', ') }) or Lang:t('info.nothing_on_them'), #got > 0 and 'success' or 'inform')
    LXRCore.Emit('lxr:frontier:looted', nil, src, netId, got)
end)
CreateThread(function() while true do Wait(600000) local cut = os.time() - (Config.Loot.rememberMinutes or 30) * 60 for k, t in pairs(looted) do if t < cut then looted[k] = nil end end end end)

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
