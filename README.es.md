<div align="center">
  <img src="https://github.com/LukeZGD/DDLC-LOVE/raw/ddlclove/logo.png"/>
  <h1>DDLC-LOVE PS3</h1>
  <h3>¿Escribirás el camino hacia su corazón?</h3>
</div>

🇬🇧 [Read in English](README.md)

* **DDLC-LOVE-PS3** es un fork de [LukeZGD/DDLC-LOVE](https://github.com/LukeZGD/DDLC-LOVE) (un port de Doki Doki Literature Club hecho en Lua). Arreglé **solo la versión de PS3**, así que es únicamente para PS3.
* **Esto es un port de fans, no oficial, y no tiene nada que ver con Team Salvato. Apoyá el juego oficial, es gratis: https://ddlc.moe**
* **¿Querés la experiencia completa en PC, Switch y otras consolas? Comprá Doki Doki Literature Club Plus: https://ddlc.plus**

## Qué se arregló

Básicamente la versión vieja de PS3 andaba medio rota: si dejabas apretado el skip, las imágenes se cortaban o desaparecían, y después de un rato el juego se colgaba. Resulta que la PS3 nunca libera la memoria de las imágenes y la música, así que la RAM se terminaba rapidísimo. Esto es lo que cambié:

* **Imágenes**: se cargan una sola vez y se reutilizan (antes se recargaban en cada línea de diálogo, un desastre).
* **Sprites recortados**: les saqué los bordes transparentes que sobraban, así los sprites ocupan \~34 MB de RAM en vez de \~132 MB. Las posiciones están en `LOVE-WrapLua/PS3/trim.lua`.
* **Música por streaming** (`snd.\\\*BGMusic`): las canciones ya no se descomprimen enteras en RAM (eran 30-60 MB cada una y nunca se liberaban).
* Fuente Aller opcional (`game/assets/fonts/`), un solo tamaño de texto para todo.
* Arreglos chicos: crash de `sfxplay`, `filesystem.read/remove`, `getLanguage`.
* Log de memoria (`memlog.txt` en el USB) por si algo se rompe. Lo podés apagar con `lv1lua.memlogging = false`.

**Estado: beta.** Lo probé en una PS3 Super Slim con HEN, jugando de corrido (rompiendo el skip) hasta la escena de Yuri (Acto 2). El Acto 3 y el final no los probé, así que si llegás y algo falla, ¡abrí un issue!

## Notas

* Acá solo se soporta **PS3**. Las demás plataformas del proyecto original no las probé.
* DDLC-LOVE no funciona con mods ni traducciones que ya existen. Es solo el juego base gratuito. El contenido de DDLC Plus no está incluido, comprálo en las plataformas oficiales si lo querés.

## Cómo instalarlo

1. Bajá el `.zip` desde **Releases**.
2. Tu USB tiene que ser **FAT32 con tabla de particiones MBR** (la PS3 no lee GPT, me enteré a las malas).
3. Extraé todo el `.zip` en la raíz del USB.
4. Instalá `Lua Player PS3.pkg` desde Package Manager (necesitás CFW/[HEN](https://www.psx-place.com/threads/update-ps3hen-v3-0-0-view-latest-changes-to-the-ps3-exploit-for-superslims-noncfw-models.23955/)). Se hace una sola vez. También lo podés bajar [acá](https://store.brewology.com/ahomebrew.php?brewid=212).
5. Enchufá el USB en el [puerto USB de más a la derecha](https://postimg.cc/jnryRhtb) y abrí Lua Player PS3 desde el XMB.

## Partidas guardadas

* Ubicación: `dev\\\_usb000:/DDLC-LOVE/savedata/`
* ¿Querés empezar de cero? Borrá esa carpeta. Para elegir el idioma de nuevo, borrá solo `settings.sav`.

## Compilación

* El `.zip` del Release ya trae los assets del juego con los sprites recortados. Este repo (solo el código) no los tiene.
* Opcional: `tools/trim\\\_sprites.py` rehace los sprites recortados y `trim.lua` a partir de assets sin tocar (`pip install pillow`). ¡Ejecutalo una sola vez!
* También necesitás [LOVE-WrapLua](https://github.com/LukeZGD/LOVE-WrapLua) al lado de la carpeta del juego (`app.lua`, `script.lua` y la carpeta `LOVE-WrapLua`).

## Sobre los assets

El `.zip` del Release trae imágenes y música de Doki Doki Literature Club (modificadas: sprites recortados), igual que el proyecto original. Son de Team Salvato. Si ellos (o sus representantes) piden que los saque, los saco. Mirá sus [IP Guidelines](https://teamsalvato.com/ip-guidelines).

## Créditos

* [DDLC-LOVE](https://github.com/LukeZGD/DDLC-LOVE) y [LOVE-WrapLua](https://github.com/LukeZGD/LOVE-WrapLua) por LukeZGD, el laburo duro es todo de él
* [Lua Player PS3](https://store.brewology.com/ahomebrew.php?brewid=212) por 3141card (es lo que hace correr el juego en PS3)
* [Traducción al español](https://tradusquare.es/ficha.php?ddlc) por GlowTranslations
* Créditos de las otras plataformas (LovePotion, lpp-vita, OneLua): mirá el [README original](https://github.com/LukeZGD/DDLC-LOVE)
* Doki Doki Literature Club es de Team Salvato
* Claude porque no sé Lua jasdjasj aunque lo tuve que probar en mi PS3

## Licencia

GPL-3.0 (mirá `LICENSE`). Los cambios de este fork también son GPL-3.0.

