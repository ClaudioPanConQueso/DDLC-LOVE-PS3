<div align="center">
  <img src="https://github.com/LukeZGD/DDLC-LOVE/raw/ddlclove/logo.png"/>
  <h1>DDLC-LOVE PS3</h1>
  <h3>Will you write the way into her heart?</h3>
</div>

🇪🇸 [Leer en español](README.es.md)

* **DDLC-LOVE PS3** is a fork of [LukeZGD/DDLC-LOVE](https://github.com/LukeZGD/DDLC-LOVE) (a Doki Doki Literature Club port made in Lua). I fixed the **PS3 version only**, so yeah, it's just for PS3.
* **This is an unofficial fan port and has nothing to do with Team Salvato. Go support the official game, it's free: https://ddlc.moe**
* **Want the full experience on PC, Switch and other consoles? Buy Doki Doki Literature Club Plus: https://ddlc.plus**

## What got fixed

Basically the old PS3 version was kinda broken: if you held skip, images got cut off or disappeared, and after a while the game just froze. Turns out the PS3 never frees the memory used by images and music, so the RAM ran out fast. Here's what changed:

* **Images** load only once and get reused (before, they reloaded on every single line of dialogue, lol).
* **Trimmed sprites**: I cut the empty transparent borders, so sprites use \~34 MB of RAM instead of \~132 MB. Their positions are saved in `LOVE-WrapLua/PS3/trim.lua`.
* **Streamed music** (`snd.\*BGMusic`): songs don't get fully decompressed into RAM anymore (that was 30-60 MB each and never got freed).
* Optional Aller font (`game/assets/fonts/`), one text size for everything.
* Small fixes: `sfxplay` crash, `filesystem.read/remove`, `getLanguage`.
* Memory log (`memlog.txt` on your USB) in case something breaks. You can turn it off with `lv1lua.memlogging = false`.

**Status: beta.** I tested it on a PS3 Super Slim with HEN, playing straight through (spamming skip) until Yuri's scene (Act 2). Act 3 and the ending are untested, so if you get there and something breaks, open an issue!

## Notes

* Only **PS3** is supported here. The other platforms from the original project are untested.
* DDLC-LOVE doesn't work with existing mods or translations. It's only the free base game. DDLC Plus content isn't included, buy it from the official platforms if you want it.

## How to install

1. Download the `.zip` from **Releases**.
2. Your USB needs to be **FAT32 with MBR partition table** (the PS3 can't read GPT, I learned that the hard way).
3. Extract everything from the `.zip` to the root of the USB.
4. Install `Lua Player PS3.pkg` from Package Manager (you need CFW/[HEN](https://www.psx-place.com/threads/update-ps3hen-v3-0-0-view-latest-changes-to-the-ps3-exploit-for-superslims-noncfw-models.23955/)). You only do this once. You can also get it [here](https://store.brewology.com/ahomebrew.php?brewid=212).
5. Plug the USB into the [rightmost USB port](https://postimg.cc/jnryRhtb) and open Lua Player PS3 from the XMB.

## Save files

* Location: `dev\_usb000:/DDLC-LOVE/savedata/`
* Wanna start over? Delete that folder. To pick the language again, just delete `settings.sav`.

## Building

* The Release `.zip` already has the game assets with trimmed sprites. This repo (just the code) doesn't have them.
* Optional: `tools/trim\_sprites.py` redoes the trimmed sprites and `trim.lua` from untouched assets (`pip install pillow`). Run it only once!
* You also need [LOVE-WrapLua](https://github.com/LukeZGD/LOVE-WrapLua) next to the game folder (`app.lua`, `script.lua` and the `LOVE-WrapLua` folder).

## About the assets

The Release `.zip` has images and music from Doki Doki Literature Club (modified: trimmed sprites), same as the original project. They belong to Team Salvato. If they (or their reps) ask me to take them down, I will. Check their [IP Guidelines](https://teamsalvato.com/ip-guidelines).

## Credits

* [DDLC-LOVE](https://github.com/LukeZGD/DDLC-LOVE) and [LOVE-WrapLua](https://github.com/LukeZGD/LOVE-WrapLua) by LukeZGD, all the hard work is theirs
* [Lua Player PS3](https://store.brewology.com/ahomebrew.php?brewid=212) by 3141card (this is what actually runs the game on PS3)
* [Spanish translation](https://tradusquare.es/ficha.php?ddlc) by GlowTranslations
* Credits for the other platforms (LovePotion, lpp-vita, OneLua): check the [original README](https://github.com/LukeZGD/DDLC-LOVE)
* Doki Doki Literature Club belongs to Team Salvato

## License

GPL-3.0 (see `LICENSE`). Changes in this fork are GPL-3.0 too.

