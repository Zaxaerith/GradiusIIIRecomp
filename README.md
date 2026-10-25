# Gradius III Recomp (Windows x64 Native Recompilation)

A high-performance, native Windows x64 static binary recompilation of **Gradius III** (SNES, USA), built on the [snesrecomp](https://github.com/RetroPortingToolKit/snesrecomp) framework with an integrated [recomp-ui](https://github.com/RetroPortingToolKit/recomp-ui) launcher.

> [!IMPORTANT]
> **Legal Notice & Attribution Disclaimer:**
> - This is an independent community static binary recompilation project.
> - This project is **not** authorized, licensed, endorsed, or affiliated with Konami Digital Entertainment Co., Ltd.
> - *Gradius III* is a registered trademark and copyright of Konami Digital Entertainment Co., Ltd.
> - This repository and its releases contain **no copyrighted game assets, ROM data, or proprietary code**. You must provide your own legally dumped retail cartridge ROM of *Gradius III (USA)* to play or build.

---

## 1. System Requirements

- **Operating System:** Windows 10 / Windows 11 (x64)
- **Graphics:** OpenGL 3.1 compatible GPU
- **Dependencies:** Included in the release package (SDL2 and MinGW runtime libraries)
- **Controllers (Optional):** Xbox (360, One, Series), DualShock 4, DualSense, Nintendo Switch Pro, and standard XInput/DirectInput gamepads supported via SDL2.

---

## 2. ROM Requirements

The launcher verifies your ROM against the retail US release checksum before booting:

| Property | Expected Value |
|---|---|
| **Game Title** | Gradius III (USA) |
| **ROM Mapping** | LoROM / SHVC-1A0N-01 |
| **Region** | USA (North America) |
| **Coprocessor** | None |
| **Battery SRAM** | None |
| **File Size** | Exactly 524,288 bytes (512 KiB) |
| **CRC32** | `cd973979` |
| **SHA-256** | `93da752a0c76167d0907efa832367e5d14aab8e835b864f345c386071a9af718` |

> [!WARNING]
> Do NOT use headered ROMs (524,796 bytes), FastROM conversions, SA-1 Root patches, or slowdown elimination hacks. The recompilation reproduces authentic SNES 65816 / SlowROM timing and hardware behavior.

---

## 3. Quick Start (Precompiled Release)

1. Download and extract `GradiusIIIRecomp-windows-x64-v0.1.0-preview.zip`.
2. Launch `GradiusIiiSNESRecomp.exe`.
3. On first launch, the GUI launcher opens automatically.
4. Click **Select ROM** (or drag and drop) to select your clean, retail `Gradius III (USA).sfc` file.
5. Once verified (indicated by a green checkmark), click **PLAY** to launch into the game.
6. To bypass the launcher on subsequent launches, check **Skip Launcher** on the launcher's General tab (you can re-open it at any time with the `--launcher` command-line flag or by pressing `L` in-game).

---

## 4. Controls & Hotkeys

### Keyboard Controls (Default)

| SNES Button | Keyboard Key | Action |
|---|---|---|
| **D-Pad Up** | `Up` | Move Vic Viper Up |
| **D-Pad Down** | `Down` | Move Vic Viper Down |
| **D-Pad Left** | `Left` | Move Vic Viper Left |
| **D-Pad Right** | `Right` | Move Vic Viper Right |
| **B** | `Z` | Normal Shot / Missile |
| **Y** | `A` | Normal Shot / Rapid Fire |
| **A** | `X` | Power-Up Activation (Speed / Missile / Option / Shield) |
| **X** | `S` | Auxiliary Fire |
| **L / R** | `C` / `V` | Shoulder Buttons |
| **Start** | `Return` (Enter) | Game Start / Pause |
| **Select** | `Right Shift` | Select / Options |

> Custom key mappings can be configured directly in the launcher UI under **Controls**, or by editing `keybinds.ini`.

### Gamepad Controls

Plug in any supported controller (Xbox, PlayStation, Switch Pro, etc.). Buttons map automatically to standard SNES layouts:
- **D-Pad / Left Stick:** Directional movement
- **A / B / X / Y:** Action buttons
- **LB / RB:** L / R shoulder buttons
- **Start / Back:** Start / Select
- Dynamic controller hotplugging during gameplay is fully supported.

### System Hotkeys

| Hotkey | Function |
|---|---|
| `Alt + Enter` | Toggle Fullscreen |
| `F7` | Open In-Game Save State Menu (10 slots) |
| `F8` | Rewind Gameplay (when enabled in settings) |
| `L` / Pad `Select + L3` | Open In-Game Launcher / Settings Menu |
| `Ctrl + R` | Soft Reset Game |
| `Tab` | Fast-Forward / Turbo Mode |
| `Shift + P` / `P` | Pause / Pause Dimmed |
| `Ctrl + Up` / `Ctrl + Down` | Scale Window Up / Down |
| `Keypad +` / `Keypad -` | Volume Up / Down |
| `F` | Display Performance / FPS Overlay |

---

## 5. Audio, Video & PC Enhancements

- **recomp-ui Graphical Launcher:** Integrated configuration panel, ROM integrity verification, and mod directory management.
- **Aspect Ratio Options:** Choose between classic 4:3 CRT presentation or 8:7 square-pixel internal rendering.
- **GLSL Shader Support:** CRT filters and scanline shaders configurable in `config.ini` or via the launcher.
- **Audio Configuration:** High-fidelity 32 kHz stereo audio output via SDL2 with volume control.
- **Save States & Rewind:** Full state persistence (10 quicksave slots) with seamless audio recovery.
- **In-Game Launcher Access:** Press `L` or gamepad `Select + L3` to adjust settings mid-game without restarting.

---

## 6. Authentic SlowROM Experience

Gradius III on the Super Nintendo is widely known for intensive sprite and bullet slowdown during busy action scenes. Rather than applying artificial SA-1 co-processor overclocking or FastROM hacks, this recompilation faithfully preserves authentic 65816 CPU cycle timing and SlowROM memory access speeds. The authentic slowdown, projectile cadence, and hit detection of the 1991 retail release are accurately reproduced.

---

## 7. Game-Specific Adaptation: `$00:86CD` (`HleWaitVBlank`)

During screen transitions (title screen, weapon selection, stage transitions, continue screen, and checkpoint respawns), Gradius III executes a specialized VBlank handshake routine at `$00:86CD`. 

To integrate smoothly with SNESRecomp's beam-aligned PPU rasterizer without deadlock, a High-Level Emulation (HLE) stub `HleWaitVBlank` is provided in [`src/gen_stubs.c`](src/gen_stubs.c) and registered in [`recomp/bank00.cfg`](recomp/bank00.cfg). This stub safely updates screen brightness, resets DMA channels (`$420B`/`$420C`), manages NMI flags, and cleans up the stack, ensuring stable transitions throughout the entire game.

---

## 8. Command Line Flags

| Flag | Description |
|---|---|
| `--launcher` | Force open the graphical launcher even if `SkipLauncher` is enabled. |
| `--no-launcher` | Bypass launcher and boot directly into game using cached ROM path. |
| `--help` | Display command-line options and usage information. |

---

## 9. Building from Source

### Prerequisites

- CMake 3.22+
- Ninja build tool
- MinGW-w64 (GCC 11+) x64 toolchain (or Clang)
- Python 3.9+
- Git and Bash (e.g. Git Bash on Windows)

> [!IMPORTANT]
> **AOT Code Generation Requirement:**  
> The ahead-of-time (AOT) recompiled C code in `src/gen/` is directly derived from ROM machine code and is **never committed to the repository**. Before building a playable executable, you must regenerate `src/gen/` locally from your own legally owned ROM.

### Build Path A: Playable Native Game (Standard Build)

To build the complete native game with all 65816 routines compiled into native machine code:

```bash
# 1. Clone repository with submodules
git clone --recursive https://github.com/Zaxaerith/GradiusIIIRecomp.git
cd GradiusIIIRecomp

# 2. Generate AOT C code from your legal Gradius III (USA) ROM
# This executes SNESRecomp's static analyzer against recomp/bank00.cfg and populates src/gen/
bash tools/regen.sh --rom "/path/to/Gradius III (USA).sfc"

# 3. Configure and compile the native executable
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build -j2
```

The resulting playable executable will be located at `build/GradiusIiiSNESRecomp.exe`.

### Build Path B: Setup Host Stub (`-DSNESRECOMP_SETUP_HOST=ON`)

If you wish to compile only the lightweight launcher host without pre-generating `src/gen/`, enable `SNESRECOMP_SETUP_HOST`:

```bash
cmake -S . -B build-host -G Ninja -DCMAKE_BUILD_TYPE=Release -DSNESRECOMP_SETUP_HOST=ON
cmake --build build-host -j2
```

The resulting `build-host/GradiusIiiSNESRecomp.exe` contains the GUI launcher and the "Generate & Rebuild" wizard, allowing the end user to supply their ROM and trigger local code compilation through the interface.

---

## 10. License & Attributions

- **Gradius III Recomp (Project Source):** Licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE).
- **SNESRecomp Framework:** Developed by [RetroPortingToolKit](https://github.com/RetroPortingToolKit/snesrecomp) (PolyForm Noncommercial 1.0.0 / MIT). Copyright (c) 2026 Matthew Stanley and framework contributors.
- **recomp-ui:** Graphical launcher by Matthew Stanley ([recomp-ui](https://github.com/RetroPortingToolKit/recomp-ui)). Copyright (c) 2026 Matthew Stanley (MIT License).
- **Dear ImGui:** Copyright (c) 2014-2026 Omar Cornut (MIT License).
- **SDL2:** Copyright (c) 1997-2026 Sam Lantinga (zlib License).
- **MinGW-w64 Runtime:** Copyright (c) 2009-2026 MinGW-w64 project (ZPL / BSD-3 / GCC Runtime Exception).
- **Game-Specific Port Modifications & Glue Code:** Copyright (c) 2026 Gradius III Recomp contributors / Zaxaerith (PolyForm Noncommercial 1.0.0).
- **Third-Party Notices:** Full legal notices and licenses for fonts and third-party libraries are detailed in [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md).
- *Gradius III* is a registered trademark and copyright of Konami Digital Entertainment Co., Ltd. This project is an independent community preservation effort and is not authorized, endorsed, sponsored, or affiliated with Konami.
