--[[
    ██╗     ██╗  ██╗██████╗       ███████╗██████╗  ██████╗ ███╗   ██╗████████╗██╗███████╗██████╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔════╝██╔══██╗██╔═══██╗████╗  ██║╚══██╔══╝██║██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗█████╗  ██████╔╝██║   ██║██╔██╗ ██║   ██║   ██║█████╗  ██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══╝  ██╔══██╗██║   ██║██║╚██╗██║   ██║   ██║██╔══╝  ██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║      ██║     ██║  ██║╚██████╔╝██║ ╚████║   ██║   ██║███████╗██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝╚══════╝╚═╝  ╚═╝

    LXR Core - Frontier

    The small things a server needs and no single resource owns: how many
    strangers walk the streets, what Discord says you are doing, who has
    been standing still too long, hands in the air, a door that goes
    somewhere, whether the game's eagle eye is allowed. Every module is a
    switch; off means the code does not run.

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Product:     wolves.land / The Land of Wolves
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/GAhk8cgXe9
    GitHub:      https://github.com/LXRCore

    Version: 3.0.0
    Performance Target: density is the only per-frame module and costs what the game's own multipliers cost

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Lang = 'en'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ MODULES ═══════════════════════════════════════════════
-- ████████████████████████████████████████████████████████████████████████████████
-- ambient life, 0.0–1.0 (the game's per-frame multipliers)
Config.Density = { on = true, humans = 0.6, animals = 0.8, vehicles = 0.4 }

-- Discord rich presence (needs a Discord application id; assets are uploaded there)
Config.Presence = { on = false, appId = '', largeAsset = 'lxrcore', largeText = 'The Land of Wolves', smallAsset = 'wolf', smallText = 'wolves.land', refreshSeconds = 60,
    buttons = { { label = 'Discord', url = 'https://discord.gg/GAhk8cgXe9' }, { label = 'wolves.land', url = 'https://www.wolves.land' } } }

-- server-side idle kick: no movement for `minutes` (the server samples position; staff at `exemptGroup` are never kicked)
Config.AFK = { on = true, minutes = 30, warnAtMinutes = 25, sampleSeconds = 30, moveMetres = 1.5, exemptGroup = 'mod' }

-- hands in the air: hold the key; the game's own loop animation
Config.HandsUp = { on = true, key = 'X', dict = 'script_proc@robberies@homestead@lonnies_shack@deception', anim = 'hands_up_loop' }

-- doors that go somewhere: pairs of points through lxr-interact
Config.Teleports = {
    on = true,
    pairs = {
        -- { id = 'val_hotel_stairs', a = { coords = vector3(-311.0, 802.0, 118.9), heading = 90.0 }, b = { coords = vector3(-313.0, 806.0, 122.6), heading = 270.0 } },
    },
    distance = 1.5,
}

-- washing: the bathhouse tubs (a fee, cleanliness to full, dirt and blood gone) and any water (`/wash` standing by
-- a river or lake — cheaper and slower). Cleanliness is lxr-hud's need; without lxr-hud only the dirt is cleared.
Config.Wash = {
    on = true,
    command = 'wash',
    water = { seconds = 12, cleanliness = 60, distance = 4.0 },                       -- a wash at the water's edge
    bath = { seconds = 20, cleanliness = 100, fee = 0.50, account = 'cash' },
    pose = 'WORLD_HUMAN_CROUCH_INSPECT',                                             -- the kneel while washing (game scenario)
    -- the tubs (game coordinates of the bathhouses)
    tubs = {
        { id = 'valentine',  label = 'Valentine Bathhouse',   coords = vector3(-320.56, 762.41, 117.44) },
        { id = 'saintdenis', label = 'Saint Denis Bathhouse', coords = vector3(2632.60, -1223.79, 59.59) },
        { id = 'blackwater', label = 'Blackwater Bathhouse',  coords = vector3(-822.82, -1315.72, 43.58) },
        { id = 'rhodes',     label = 'Rhodes Bathhouse',      coords = vector3(1340.11, -1379.60, 84.28) },
        { id = 'strawberry', label = 'Strawberry Bathhouse',  coords = vector3(-1816.45, -372.44, 166.50) },
        { id = 'annesburg',  label = 'Annesburg Bathhouse',   coords = vector3(2950.42, 1332.15, 44.44) },
        { id = 'vanhorn',    label = 'Van Horn Bathhouse',    coords = vector3(2986.31, 568.27, 47.85) },
    },
}

-- the game's eagle eye (tracking vision): false locks it for everyone
Config.EagleEye = { on = true, allowed = false }

-- the game's lawmen ignore players unless they are "wanted", and RedM has no wanted state: this sets
-- ped config flag 98 (CanAttackNonWantedPlayerAsLaw) on every lawman the game creates, so they draw
-- and return fire like they would in the story. `groups` are relationship groups (REL_COP is the
-- one the game's law peds carry); `flag` is the config flag id
Config.Law = { reactToPlayers = true, groups = { 'REL_COP' }, flag = 98 }

Config.Debug = { printBanner = true }
