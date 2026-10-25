# Gradius III Recomp — Release Notes (v0.1.0-preview)

**Release Date:** October 25, 2026  
**Build Target:** Windows x64 Native  
**Framework Baseline:** snesrecomp `82b4acb` + recomp-ui `eaf99ca`

We are excited to present the first public technical preview release of **Gradius III Recomp**, an authentic static recompilation of the Super Nintendo classic *Gradius III* (USA) running natively on modern 64-bit Windows.

---

## Highlights

- **First Windows x64 Native Preview:** Powered by the [snesrecomp](https://github.com/RetroPortingToolKit/snesrecomp) static AOT recompilation engine, generating native x86_64 machine code for 65816 logic with zero JIT overhead.
- **Full-Game Human Playthrough Verified:** The port has been thoroughly played through from beginning to end (all stages and bosses through the ending credits) by the developer, confirming stable progression, authentic sprite collision, correct weapon power-up mechanics, and crash-free operation.
- **Official recomp-ui Graphical Launcher:** Integrated Dear ImGui launcher providing intuitive ROM file picking, real-time SHA-256 integrity verification, customizable presentation settings, and mod directory support.
- **Plug-and-Play Controller & Keyboard Input:** Dynamic controller hotplugging for modern Xbox, DualShock 4, DualSense, Nintendo Switch Pro, and standard XInput/DirectInput controllers, alongside fully customizable keyboard mapping via GUI or `keybinds.ini`.
- **Display & Audio Enhancements:** Switch between classic 4:3 CRT presentation and 8:7 square-pixel internal rendering, with VSync, integer scaling, optional GLSL shaders, and clean 32 kHz stereo audio through SDL2.
- **Save States & Rewind Support:** Instant 10-slot save state management (`F7`) and real-time rewind (`F8`), complete with seamless audio recovery and state persistence.
- **Authentic SlowROM Experience:** Faithfully preserves the authentic 65816 cycle execution speeds and characteristic hardware slowdown of the original retail cartridge. No artificial SA-1 overclocking or speed hacks have been applied.
- **Engineered `$00:86CD` Handshake Adaptation:** Custom High-Level Emulation (HLE) routine cleanly reconciles Gradius III's unique screen-transition VBlank handshake with the framework's beam-aligned PPU rasterizer without deadlock.

---

## Requirements

- **Operating System:** Windows 10 or Windows 11 (64-bit)
- **Graphics:** OpenGL 3.1 compatible GPU
- **Retail Game ROM:** You must supply your own legally acquired, unmodified retail ROM of **Gradius III (USA)**:
  - Format: Unheadered LoROM (`.sfc` / `.smc`)
  - Size: Exactly 524,288 bytes (512 KiB)
  - SHA-256: `93da752a0c76167d0907efa832367e5d14aab8e835b864f345c386071a9af718`
  - CRC32: `cd973979`

> [!NOTE]
> Headered dumps, non-US region versions, and ROM hacks (such as FastROM or SA-1 conversions) are rejected by the launcher to ensure strict emulation accuracy.

---

## Known Limitations

- **Netplay:** Multiplayer netplay is disabled in this single-player focused preview release.
- **SRAM Saves:** Gradius III originally featured no battery-backed SRAM; progress is preserved using the built-in 10-slot savestate system.
- **Fullscreen Mode:** Fullscreen currently utilizes standard borderless fullscreen on multi-monitor setups.

---

## File Verification

| Archive | File Size | SHA-256 Checksum |
|---|---|---|
| `GradiusIIIRecomp-windows-x64-v0.1.0-preview.zip` | ~5.65 MB | *See SHA256SUMS.txt* |
