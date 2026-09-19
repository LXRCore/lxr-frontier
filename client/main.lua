--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Client: density, presence, hands up, doors, eagle eye
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local F = LXRFrontier
local N = Citizen.InvokeNative
local LXR = exports['lxr-core']:GetLXR()

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐎 DENSITY — the game's per-frame multipliers
-- ═══════════════════════════════════════════════════════════════════════════════
if Config.Density.on then
    CreateThread(function()
        local h, a, v = F.Density(Config.Density.humans), F.Density(Config.Density.animals), F.Density(Config.Density.vehicles)
        while true do   -- perf:frame — "ThisFrame" natives: the game forgets them each frame, there is no other way
            N(0xBA0980B5C0A11924, h)   -- SetAmbientHumanDensityMultiplierThisFrame
            N(0xAB0D553FE20A6E25, h)   -- SetAmbientPedDensityMultiplierThisFrame
            N(0x28CB6391ACEDD9DB, h)   -- SetScenarioHumanDensityMultiplierThisFrame
            N(0x7A556143A1C03898, h)   -- SetScenarioPedDensityMultiplierThisFrame
            N(0xC0258742B034DFAF, a)   -- SetAmbientAnimalDensityMultiplierThisFrame
            N(0xDB48E99F8E064E56, a)   -- SetScenarioAnimalDensityMultiplierThisFrame
            N(0xFEDFA97638D61D4A, v)   -- SetParkedVehicleDensityMultiplierThisFrame
            N(0x1F91D44490E1EA0C, v)   -- SetRandomVehicleDensityMultiplierThisFrame
            N(0x606374EBFC27B133, v)   -- SetVehicleDensityMultiplierThisFrame
            Wait(0)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 💬 PRESENCE
-- ═══════════════════════════════════════════════════════════════════════════════
if Config.Presence.on and Config.Presence.appId ~= '' then
    CreateThread(function()
        local P = Config.Presence
        SetDiscordAppId(P.appId)
        SetDiscordRichPresenceAsset(P.largeAsset) SetDiscordRichPresenceAssetText(P.largeText)
        SetDiscordRichPresenceAssetSmall(P.smallAsset) SetDiscordRichPresenceAssetSmallText(P.smallText)
        for i, b in ipairs(P.buttons or {}) do if i <= 2 then SetDiscordRichPresenceAction(i - 1, b.label, b.url) end end
        while true do
            SetRichPresence(Lang:t('presence.line', { name = LXRCore.Brand.name or '', n = GlobalState['lxr:players'] or 0 }))
            Wait(P.refreshSeconds * 1000)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🙌 HANDS UP
-- ═══════════════════════════════════════════════════════════════════════════════
if Config.HandsUp.on then
    local up = false
    local function setHands(on)
        local ped = PlayerPedId()
        if on then
            if IsEntityDead(ped) or IsPedLassoed(ped) or Player(GetPlayerServerId(PlayerId())).state.cuffed then return end
            RequestAnimDict(Config.HandsUp.dict)
            local t = GetGameTimer() + 3000
            while not HasAnimDictLoaded(Config.HandsUp.dict) and GetGameTimer() < t do Wait(10) end
            TaskPlayAnim(ped, Config.HandsUp.dict, Config.HandsUp.anim, 2.0, -2.0, -1, 67109393, 0.0, false, 1245184, false, 'UpperbodyFixup_filter', false)
            up = true
        elseif up then
            StopAnimTask(ped, Config.HandsUp.dict, Config.HandsUp.anim, 1.0)
            up = false
        end
        LocalPlayer.state:set('handsup', up, true)
    end
    RegisterCommand('+handsup', function() setHands(true) end, false)
    RegisterCommand('-handsup', function() setHands(false) end, false)
    RegisterKeyMapping('+handsup', 'Hands up', 'keyboard', Config.HandsUp.key)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🚪 DOORS THAT GO SOMEWHERE
-- ═══════════════════════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🛁 WASHING — the tubs, or any water
-- ═══════════════════════════════════════════════════════════════════════════════
local washing = false
local function nearWater()
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local f = GetEntityForwardVector(ped)
    for _, d in ipairs({ 1.0, 2.0, 3.5 }) do
        local p = c + f * d
        local ok, h = GetWaterHeight(p.x, p.y, p.z)
        if ok and math.abs(h - p.z) < 2.0 then return true end
    end
    return false
end
local function wash(kind, tubId)
    if washing or not Config.Wash.on then return end
    local W = Config.Wash[kind]
    washing = true
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, joaat(Config.Wash.pose), -1, true, false, false, false)
    local done = true
    if GetResourceState('lxr-nui') == 'started' then
        local d = nil
        exports['lxr-nui']:Progress({ label = Lang:t('ui.washing'), duration = W.seconds * 1000, canCancel = true }, function(ok) d = ok end)
        while d == nil do Wait(50) end
        done = d
    else Wait(W.seconds * 1000) end
    ClearPedTasks(ped)
    washing = false
    if not done then return end
    TriggerServerEvent('lxr-frontier:server:washed', kind, tubId)
end
RegisterNetEvent('lxr-frontier:client:washed', function()
    local ped = PlayerPedId()
    ClearPedEnvDirt(ped)
    ClearPedBloodDamage(ped)
    SetPedDirtCleaned(ped, 0.0, -1, true, true)   -- (ped, 0f, -1, true, true) as the game scripts call it
    LXRCore.Notify(Lang:t('info.washed'), 'success')
end)
RegisterCommand(Config.Wash.command or 'wash', function()
    if not Config.Wash.on or not LocalPlayer.state.isLoggedIn then return end
    if not nearWater() then return LXRCore.Notify(Lang:t('error.no_water'), 'error') end
    wash('water')
end, false)
if Config.Wash.on then
    CreateThread(function()
        while GetResourceState('lxr-interact') ~= 'started' do Wait(1000) end
        for _, tub in ipairs(Config.Wash.tubs) do
            exports['lxr-interact']:AddPoint('lxr-frontier:tub:' .. tub.id, tub.coords, { label = tub.label, distance = 2.0, options = {
                { label = Lang:t('ui.take_bath', { fee = ('%.2f'):format(Config.Wash.bath.fee or 0) }), key = 'E', onSelect = function() wash('bath', tub.id) end },
            }})
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 💀 SEARCHING THE DEAD
-- ═══════════════════════════════════════════════════════════════════════════════
if Config.Loot.on then
    CreateThread(function()
        while GetResourceState('lxr-interact') ~= 'started' do Wait(1000) end
        local busy = false
        exports['lxr-interact']:AddGlobal('lxr-frontier:body', 'ped', { label = Lang:t('ui.body'), distance = Config.Loot.distance, options = {
            { label = Lang:t('ui.search_body'), key = 'R', canInteract = function(e) return e and e ~= 0 and IsEntityDead(e) and not IsPedAPlayer(e) and NetworkGetEntityIsNetworked(e) end,
              onSelect = function(d)
                  if busy then return end
                  busy = true
                  local ped = PlayerPedId()
                  TaskStartScenarioInPlace(ped, joaat('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
                  local done = true
                  if GetResourceState('lxr-nui') == 'started' then
                      local r = nil
                      exports['lxr-nui']:Progress({ label = Lang:t('ui.searching'), duration = Config.Loot.seconds * 1000, canCancel = true }, function(ok) r = ok end)
                      while r == nil do Wait(50) end
                      done = r
                  else Wait(Config.Loot.seconds * 1000) end
                  ClearPedTasks(ped)
                  busy = false
                  if done then TriggerServerEvent('lxr-frontier:server:loot', NetworkGetNetworkIdFromEntity(d.entity)) end
              end },
        }})
    end)
end

if Config.Teleports.on and #Config.Teleports.pairs > 0 then
    CreateThread(function()
        while GetResourceState('lxr-interact') ~= 'started' do Wait(1000) end
        for _, pair in ipairs(Config.Teleports.pairs) do
            for _, side in ipairs({ 'a', 'b' }) do
                local here, there = pair[side], F.Other(pair, side)
                exports['lxr-interact']:AddPoint(('lxr-frontier:%s:%s'):format(pair.id, side), here.coords, { label = pair.label or Lang:t('ui.door'), distance = Config.Teleports.distance, options = {
                    { label = Lang:t('ui.go_through'), key = 'J', onSelect = function()
                        DoScreenFadeOut(300) Wait(350)
                        local ped = PlayerPedId()
                        SetEntityCoords(ped, there.coords.x, there.coords.y, there.coords.z, false, false, false, false)
                        if there.heading then SetEntityHeading(ped, there.heading) end
                        Wait(200) DoScreenFadeIn(300)
                    end },
                }})
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🦅 EAGLE EYE
-- ═══════════════════════════════════════════════════════════════════════════════
if Config.EagleEye.on then
    CreateThread(function()
        while true do
            N(0xA63FCAD3A6FEC6D2, PlayerId(), Config.EagleEye.allowed)   -- EnableEagleeye
            Wait(5000)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ⭐ THE LAW REACTS — lawmen shoot back at players (they do not, out of the box)
-- ═══════════════════════════════════════════════════════════════════════════════
if Config.Law.reactToPlayers then
    local groups = {}
    for _, g in ipairs(Config.Law.groups) do groups[joaat(g)] = true end
    local function arm(ped)
        if ped == 0 or not DoesEntityExist(ped) or IsPedAPlayer(ped) then return end
        if groups[N(0x7DBDD04862D95F04, ped, Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())] then   -- GetPedRelationshipGroupHash
            N(0x1913FE4CBF41C463, ped, Config.Law.flag, true)   -- SetPedConfigFlag
        end
    end
    -- every lawman the game makes from now on …
    LXR.Game.On('EVENT_PED_CREATED', 1, function(data) arm(data[1]) end)
    -- … and the ones already standing when this resource started
    CreateThread(function()
        Wait(2000)
        for _, ped in ipairs(GetGamePool('CPed')) do arm(ped) end
    end)
end

exports('HandsUp', function() return LocalPlayer.state.handsup == true end)
