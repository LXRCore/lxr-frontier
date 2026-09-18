--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Shared rules: the little arithmetic
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

LXRFrontier = LXRFrontier or {}
local F = LXRFrontier

---Clamp a density multiplier to 0..1.
function F.Density(v) return math.max(0.0, math.min(1.0, tonumber(v) or 1.0)) end

---Has a player moved since the last sample?
function F.Moved(a, b)
    if not a or not b then return true end
    return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2) >= Config.AFK.moveMetres
end

---What the idle timer calls for: nil | 'warn' | 'kick'.
function F.Idle(idleSeconds)
    if idleSeconds >= Config.AFK.minutes * 60 then return 'kick' end
    if Config.AFK.warnAtMinutes > 0 and idleSeconds >= Config.AFK.warnAtMinutes * 60 then return 'warn' end
    return nil
end

---Modules that are on, sorted (for the banner and tests).
function F.Modules()
    local out = {}
    for _, k in ipairs({ 'Density', 'Presence', 'AFK', 'HandsUp', 'Teleports', 'EagleEye' }) do if Config[k] and Config[k].on then out[#out + 1] = k end end
    return out
end

---The other side of a teleport pair.
function F.Other(pair, side) return side == 'a' and pair.b or pair.a end
