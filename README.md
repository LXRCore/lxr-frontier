<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-frontier — The small things, for LXRCore

What a server needs and no single resource owns. Every module is a switch
in `config.lua`; off means the code does not run. There is no interface.

## Modules

| Module | What it does | Side |
|---|---|---|
| `Density` | ambient humans, animals and vehicles at 0–1 of the game's own (per-frame multipliers) | client |
| `Presence` | Discord rich presence: assets, two buttons, "<server> — n in town" | client |
| `AFK` | idle kick from server-side position samples; a warning first; staff exempt | server |
| `HandsUp` | hold a key, hands in the air; `LocalPlayer.state.handsup` for robberies | client |
| `Teleports` | pairs of points through lxr-interact with a fade | client |
| `EagleEye` | lock or allow the game's tracking vision | client |
| `Law` | the game's lawmen shoot back at players (ped config flag 98 on every REL_COP ped the game creates — RedM has no wanted state, so they ignore players otherwise) | client |

Consumables are not here: the core catalog's `use` and `effects` already
handle food, drink and medicine. Model blacklists and event checks are
lxr-warden's.

## Install

```cfg
ensure lxr-core
ensure lxr-interact   # optional: teleport doors
ensure lxr-frontier
```

## API

| Name | Side | Purpose |
|---|---|---|
| `IdleSeconds(src)` | server | how long a player has stood still |
| `HandsUp()` | client | are my hands up |

## Licence

© 2026 iBoss21 / LXRCore — All Rights Reserved. See `LICENSE`.
