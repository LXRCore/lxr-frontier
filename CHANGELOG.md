# Changelog

## 3.0.0 — 2026-09-19
* Searching the dead: a card on any dead person of the world — a few coins and sometimes a thing from the table, once per body (`Config.Loot`); event `lxr:frontier:looted`.
* Washing: a bath at the seven bathhouse tubs for a fee (cleanliness to full, dirt and blood gone) and `/wash` at any water's edge (`Config.Wash`); the need is lxr-hud's.
* LXRCore v3 release line: every resource ships as 3.0.0 from here (the entries below are the road to it).
* The density loop is marked as the one reviewed per-frame loop ("ThisFrame" natives).

## 3.1.0 — 2026-09-19
* `Config.Law`: lawmen react to players (config flag 98 on REL_COP peds via the core's game-event poller). NOT TESTED in game yet.

## 3.0.0 — 2026-09-18

Rebuilt on the LXRCore v3 native API as lxr-frontier (was lxr-smallresources). Nothing of the earlier build remains.

* Density, presence, idle kick, hands up, teleport doors, eagle eye — each a switch
* Consumables left to the core catalog; blacklists and event checks left to lxr-warden
* Locales EN / KA; offline tests
