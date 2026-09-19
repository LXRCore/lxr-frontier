--[[
    LXR Core - Frontier

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Product:     wolves.land / The Land of Wolves
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/ZHMKVYyhBa (development)
    GitHub:      https://github.com/LXRCore

    Version: 3.0.0
    Performance Target: density is the only per-frame module

    Framework Support:
    - LXR Core v3 (Native — GetCoreObject / GetLXR)

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

name 'lxr-frontier'
author 'iBoss21 / LXRCore'
description 'LXRCore v3 frontier: the small things — ambient density, presence, idle kick, hands up, doors that go somewhere, eagle eye'
version '3.1.0'
repository 'https://github.com/LXRCore/lxr-frontier'

shared_scripts {
    'shared/locale.lua',
    'locales/*.lua',
    'config.lua',
    'shared/rules.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies { 'lxr-core' }
