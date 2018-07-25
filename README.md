# NeoCD-Wii

NeoCD-Wii is a port of the NEO-CD REDUX GameCube emulator, originally coded by Softdev
and ported to Wii by Wiimpathy (https://github.com/Wiimpathy/Neocd-Wii).
This is a Neo-Geo CD emulator.

Wiimpathy & Jacobeian did their best to improve this emulator but abandoned the project in Nov/2012.
https://gbatemp.net/threads/neogeo-cd.299808/page-8#post-4466267


## Why 

I have absolutely zero experience in gx or coding for wii, but Neo Geo CD emulation on a cheap platform that looks like the real thing on both crt and fixed-pixel-devices seems to be a good reason to fork this repository, add some stuff to this readme and hoping get some help reviving this project.


## Installation

Extract the zip on your SD card/USB drive. Create a folder and put your roms in it.
In order to enable USB2 you need ios 202. 


### BIOS File

The emulator needs a NeoGeo CD/Z bios to run. Put your NeoCD.bin file into a bios folder in the root of the SD card (e.g. SD:/BIOS/NeoCD.bin).

Working bios files:

NeoCD.bin md5 f39572af7584cb5b3f70ae8cc848aba2 crc32 df9de490

NeoCD.bin md5 11526d58d4c524daef7d5d677dc6b004 crc32 33697892


### MP3 MUSIC

For each game disc, you should create a subdirectory, and copy the game data files there. Inside this directory, create a subdirectory called MP3, and copy the audio tracks there, encoded to mp3. These should be name Trackxx.mp3. MP3 files can be 44.1Khz or 48Khz. To help the emulator along, encode at 128kbps or better. For example, for NEOGAME, you should have a directory tree like this: /BIOS/NEOCD.BIN /NEOGAME/IPL.TXT and all other data files /NEOGAME/MP3/TRACK02.MP3 /NEOGAME/MP3/TRACK03.MP3 and so on for all audio tracks. NOTE: Audio tracks should be numbered around the data track. For example, if data track is 1, the first audio track would be 2. The names must not contain spaces, but be exactly as shown above.


## Thanks

Jacobeian, Softdev, DevkitPPC/libogc dreamteam, and L. 


http://wiibrew.org/wiki/NeoCD-Wii



