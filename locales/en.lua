--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-FRONTIER — Locale: English (canonical)
     Developer   : iBoss21 | Brand : LXRCore | https://www.lxrcore.com
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

Locale.Register('en', {
    afk = { warn = 'You have been standing still a long while. %{minutes} minutes before the server lets you go.', kicked = 'Idle for %{minutes} minutes. Come back when you are back.' },
    presence = { line = '%{name} — %{n} in town' },
    ui = { door = 'Door', go_through = 'Go through', washing = 'Washing', take_bath = 'Take a bath ($%{fee})', body = 'Body', search_body = 'Search the body', searching = 'Going through the pockets' },
    info = { washed = 'You are clean.', already_searched = 'Somebody has been through these pockets.', found = 'Found %{what}.', nothing_on_them = 'Nothing on them.' },
    error = { no_water = 'No water here.', no_money = 'You cannot pay for the bath.' },
})
