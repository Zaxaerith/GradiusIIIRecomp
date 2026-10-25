# Gradius III Recomp (Windows x64 Native Recompilation)

A high-performance, native Windows x64 recompilation of **Gradius III** (SNES, USA), built on the [snesrecomp](https://github.com/RetroPortingToolKit/snesrecomp) static binary recompilation framework with integrated [recomp-ui](https://github.com/RetroPortingToolKit/recomp-ui) launcher.

> [!IMPORTANT]
> **Legal Notice:** This repository contains no game assets, ROM data, or proprietary code. You must provide your own legally dumped retail ROM of *Gradius III (USA)* to play.

---

## 1. System Requirements

- **Operating System:** Windows 10 / Windows 11 (x64)
- **Graphics:** OpenGL 3.1 compatible GPU
- **Dependencies:** Included in release package (SDL2 and MinGW runtime)
- **Controllers (Optional):** Xbox, DualShock 4, DualSense, Nintendo Switch Pro, and standard XInput/DirectInput gamepads supported via SDL2.

---

## 2. ROM Requirements

The launcher verifies your ROM against the retail US release checksum before booting:

| Field | Expected Value |
|---|---|
| **Title** | Gradius III (USA) |
| **Mapping** | LoROM |
| **Region** | USA (North America) |
| **Coprocessor** | None |
| **File Size** | Exactly 524,288 bytes (512 KiB) |
| **CRC32** | `cd973979` |
| **SHA-256** | `93da752a0c76167d0907efa832367e5d14aab8e835b864f345c386071a9af718` |

> [!WARNING]
> Do NOT use headered ROMs (524,796 bytes), FastROM conversions, SA-1 Root patches, or slowdown elimination hacks. The recompilation reproduces authentic SNES 65816 / SlowROM timing and hardware behavior.

---

## 3. Quick Start

1. Extract the release package `GradiusIIIRecomp-windows-x64-v0.1.0-preview-rc1.zip` to any folder.
2. Launch `GradiusIiiSNESRecomp.exe`.
3. On first launch, the GUI launcher will appear. Click **Select ROM** (or drag and drop) to select your `Gradius III (USA).sfc` file.
4. Once verified (green checkmark), click **PLAY** to launch into the game!
5. To skip the launcher on subsequent launches, check **Skip Launcher** on the launcher's General tab.

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

> Key mappings can be customized in the launcher UI under **Controls**, or by editing `keybinds.ini`.

### Gamepad Controls

Plug in any supported controller (Xbox, PlayStation, Switch Pro, etc.). Buttons map automatically to standard SNES layouts:
- **D-Pad / Left Stick:** Directional movement
- **A / B / X / Y:** Action buttons
- **LB / RB:** L / R shoulder buttons
- **Start / Back:** Start / Select
- Hotplugging controllers during gameplay is fully supported.

### System Hotkeys

| Hotkey | Function |
|---|---|
| `Alt + Enter` | Toggle Fullscreen |
| `F7` | Open In-Game Save State Menu (10 slots) |
| `F8` | Rewind Gameplay (when enabled in settings) |
| `L` | Open In-Game Launcher / Settings Menu |
| `Ctrl + R` | Soft Reset Game |
| `Tab` | Fast-Forward / Turbo Mode |
| `Shift + P` / `P` | Pause / Pause Dimmed |
| `Ctrl + Up` / `Ctrl + Down` | Scale Window Up / Down |
| `Keypad +` / `Keypad -` | Volume Up / Down |
| `F` | Display Performance / FPS Overlay |

---

## 5. Features & PC Enhancements

- **recomp-ui Graphical Launcher:** Integrated settings configuration, ROM integrity verification, and mod management.
- **Aspect Ratio Options:** Choose between classic 4:3 CRT presentation or 8:7 square pixel internal rendering.
- **GLSL Shader Support:** CRT filters and scanline shaders configurable in `config.ini` or via launcher.
- **Audio Configuration:** High-fidelity 32 kHz stereo audio output via SDL2 with volume control.
- **Save States & Rewind:** Full state persistence (10 quicksave slots) with seamless audio recovery.
- **In-Game Launcher Access:** Press `L` or gamepad `Select + L3` to adjust settings mid-game without restarting.

---

## 6. Command Line Flags

| Flag | Description |
|---|---|
| `--launcher` | Force open the graphical launcher even if `SkipLauncher` is enabled. |
| `--no-launcher` | Bypass launcher and boot directly into game using cached ROM path. |
| `--help` | Display command-line options and usage information. |

---

## 7. Building from Source

### Prerequisites

- CMake 3.22+
- Ninja build tool
- MinGW-w64 (GCC 11+) x64 toolchain
- Git

### Build Instructions

```powershell
# 1. Clone repository with submodules
git clone --recursive <repo-url> GradiusIIIRecomp
cd GradiusIIIRecomp

# 2. Configure project
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

# 3. Build native executable
cmake --build build -j2
```

The resulting executable will be located at `build/GradiusIiiSNESRecomp.exe`.

---

## 8. License & Acknowledgments

- **Gradius III Recomp:** Licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE).
- **SNESRecomp Framework:** Developed by [RetroPortingToolKit](https://github.com/RetroPortingToolKit/snesrecomp).
- **recomp-ui:** Graphical launcher by Matthew Stanley ([recomp-ui](https://github.com/RetroPortingToolKit/recomp-ui)).
- **Third-Party Notices:** See [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) for full licensing details of Dear ImGui, SDL2, fonts, and runtime components.
- *Gradius III* is a registered trademark of Konami Digital Entertainment Co., Ltd. This project is not affiliated with, endorsed by, or sponsored by Konami.
