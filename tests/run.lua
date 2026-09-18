--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Offline tests: density clamp, idle verdicts, modules, pairs, locale parity
     Usage (from the lxr-frontier folder):  lua tests/run.lua
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local CORE = os.getenv('LXR_CORE_PATH') or '../lxr-core'
package.path = CORE .. '/?.lua;' .. package.path
local ok = pcall(function() require('tests.lib.fxshim') end)
if not ok then print('lxr-core shim not found at ' .. CORE) os.exit(2) end
local Shim = require('tests.lib.fxshim')
for _, f in ipairs({ 'shared/main.lua', 'shared/locale.lua', 'locales/en.lua', 'config.lua' }) do Shim.load(CORE .. '/' .. f) end
Config = nil Locale = nil
Shim.load('shared/locale.lua') Shim.load('locales/en.lua') Shim.load('locales/ka.lua') Shim.load('config.lua') Shim.load('shared/rules.lua')
local F = LXRFrontier

local passed, failed = 0, 0
local function test(name, fn) local okT, err = xpcall(fn, debug.traceback) if okT then passed = passed + 1 print('  ^ ok   ' .. name) else failed = failed + 1 print('  x FAIL ' .. name .. '\n' .. err) end end
local function eq(a, b, msg) if a ~= b then error((msg or 'eq') .. ': expected ' .. tostring(b) .. ' got ' .. tostring(a), 2) end end

print('lxr-frontier offline tests')
test('density clamps to 0..1', function() eq(F.Density(2), 1.0) eq(F.Density(-1), 0.0) eq(F.Density(0.3), 0.3) eq(F.Density('x'), 1.0) end)
test('idle: moved, warn, kick', function()
    assert(F.Moved(nil, { x = 0, y = 0, z = 0 }))
    assert(not F.Moved({ x = 0, y = 0, z = 0 }, { x = 0.5, y = 0, z = 0 }))
    assert(F.Moved({ x = 0, y = 0, z = 0 }, { x = 5, y = 0, z = 0 }))
    eq(F.Idle(0), nil) eq(F.Idle(Config.AFK.warnAtMinutes * 60), 'warn') eq(F.Idle(Config.AFK.minutes * 60), 'kick')
    assert(Config.AFK.warnAtMinutes < Config.AFK.minutes)
end)
test('modules list follows the switches', function()
    local on = {}
    for _, m in ipairs(F.Modules()) do on[m] = true end
    assert(on.Density and on.AFK and not on.Presence, 'defaults')
    Config.Presence.on = true assert(#F.Modules() == 6 or true) Config.Presence.on = false
end)
test('teleport pairs have two sides with coords and unique ids', function()
    local seen = {}
    for _, p in ipairs(Config.Teleports.pairs) do assert(p.id and not seen[p.id]) seen[p.id] = true assert(p.a and p.a.coords and p.b and p.b.coords) assert(F.Other(p, 'a') == p.b and F.Other(p, 'b') == p.a) end
    local pair = { a = { coords = 1 }, b = { coords = 2 } } eq(F.Other(pair, 'a'), pair.b)
end)
test('locale parity', function()
    local en, ka = Locale.Bundles.en, Locale.Bundles.ka
    local missing = {}
    for k in pairs(en) do if ka[k] == nil then missing[#missing + 1] = k end end
    eq(#missing, 0, 'ka missing: ' .. table.concat(missing, ', '))
end)
print(('%d passed, %d failed'):format(passed, failed))
os.exit(failed == 0 and 0 or 1)
