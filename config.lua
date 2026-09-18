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
    Discord:     https://discord.gg/ZHMKVYyhBa (development)
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
    buttons = { { label = 'Discord', url = 'https://discord.gg/ZHMKVYyhBa' }, { label = 'wolves.land', url = 'https://www.wolves.land' } } }

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

-- the game's eagle eye (tracking vision): false locks it for everyone
Config.EagleEye = { on = true, allowed = false }

Config.Debug = { printBanner = true }
