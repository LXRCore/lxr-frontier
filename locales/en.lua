--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Locale: English (canonical)
     Developer   : iBoss21 | Brand : LXRCore | https://www.lxrcore.com
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

Locale.Register('en', {
    afk = { warn = 'You have been standing still a long while. %{minutes} minutes before the server lets you go.', kicked = 'Idle for %{minutes} minutes. Come back when you are back.' },
    presence = { line = '%{name} — %{n} in town' },
    ui = { door = 'Door', go_through = 'Go through', washing = 'Washing', take_bath = 'Take a bath ($%{fee})' },
    info = { washed = 'You are clean.' },
    error = { no_water = 'No water here.', no_money = 'You cannot pay for the bath.' },
})
