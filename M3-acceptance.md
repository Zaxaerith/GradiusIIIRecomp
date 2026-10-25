# Gradius III SNESRecomp — Phase M3 验收报告

- **报告生成时间**: 2026-10-25
- **项目目录**: `D:\Project\GameRecomp\GradiusIIIRecomp`
- **阶段目标**: recomp-ui 集成与 v0.1.0-preview-rc1 本地发行候选包验证
- **最终状态**: **PREVIEW_RC_READY_FOR_USER_ACCEPTANCE**

---

## 一、版本与框架基线

| 组件 | 版本 / Commit | 说明 |
|---|---|---|
| **GradiusIIIRecomp** | `main` 分支 | 本机 Windows x64 静态重编译工程 |
| **SNESRecomp** | `82b4acbf909095184cee32a20cf6f78557598234` | 静态 65816 AOT 框架与 Desktop Host 运行时 |
| **recomp-ui** | `eaf99cacd861707ca84726fe8a416785b2b0daf2` | 官方 Dear ImGui 图形启动器子模块 |
| **ROM 身份** | Gradius III (USA) | 524,288 字节，LoROM，无协处理器 |
| **ROM SHA-256** | `93DA752A0C76167D0907EFA832367E5D14AAB8E835B864F345C386071A9AF718` | 零售原版校验 |
| **ROM CRC32** | `CD973979` | 零售原版校验 |

---

## 二、发行候选包 (Release Candidate) 信息

- **归档路径**: `D:\Project\GameRecomp\GradiusIIIRecomp\dist\GradiusIIIRecomp-windows-x64-v0.1.0-preview-rc1.zip`
- **文件大小**: `5,927,819` 字节 (约 5.65 MB)
- **SHA-256**: `CFE344F4BED53A93B8CCF72A536FF122F55A6E519E7A751CD83B58E1A2BE2767`
- **校验文件**: `D:\Project\GameRecomp\GradiusIIIRecomp\dist\SHA256SUMS.txt`

### 归档文件白名单清单

```text
GradiusIIIRecomp-windows-x64-v0.1.0-preview-rc1/
├── GradiusIiiSNESRecomp.exe         (8,099,583 字节, 原生 Windows x64 二进制，内嵌 recomp-ui)
├── SDL2.dll                         (1,785,856 字节, SDL 2.32.8 官方运行时)
├── libgcc_s_seh-1.dll               (143,872 字节, MinGW-w64 运行时库)
├── libstdc++-6.dll                  (2,594,304 字节, MinGW-w64 C++ 运行时库)
├── libwinpthread-1.dll              (56,832 字节, MinGW-w64 POSIX 线程库)
├── config.ini                       (1,024 字节, 生产默认配置：4:3比例、VSync开启、32kHz音频)
├── keybinds.ini                     (658 字节, 默认键盘键位映射)
├── README.md                        (5,827 字节, 完整运行指南、控制说明与免责声明)
├── LICENSE                          (3,892 字节, PolyForm Noncommercial 1.0.0 许可证)
├── THIRD_PARTY_LICENSES.md          (844 字节, 包含 ImGui、SDL2、字体、MinGW 许可声明)
├── assets/
│   ├── fonts/
│   │   ├── LatoLatin-Bold.ttf
│   │   ├── LatoLatin-Regular.ttf
│   │   ├── NotoSansSymbols2-Regular.ttf
│   │   └── OpenMoji-black-glyf.ttf
│   └── img/
│       ├── brand_mark.tga
│       ├── flags.png
│       ├── pad.tga
│       ├── verdict_bad.tga
│       ├── verdict_none.tga
│       ├── verdict_ok.tga
│       └── verdict_warn.tga
└── mods/
    └── preloaded/
        └── packages/
            └── .gitkeep
```

### 黑名单门禁审核结果

- [x] **无任何 ROM 文件**（无 `.sfc` / `.smc` / `.bin` / `.rom`）
- [x] **无任何构建残留与缓存**（无 `rom.cfg` / `config.local.ini`）
- [x] **无开发期源文件与中间件**（无 `.c` / `.h` / `.cpp` / `.o` / `.obj` / `.ninja` / `.ps1` / `.sh`）
- [x] **无用户存档残留**（无 `saves/` 目录与 `.sav` / `.srm` 文件）

---

## 三、独立中等完整性 (Medium Integrity) 自动化验证

验证工具脚本：`tools/verify_rc1_standalone.ps1`
测试环境目录：`C:\Users\KEPLER\AppData\Local\GradiusIIIRCValidation`（完全独立于开发工程目录）
系统 PATH 清理：严格清空外部开发链，仅保留 Windows 原生系统目录：`C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem`。

### 自动化验证步骤及结果

| 测试项目 | 测试场景与操作 | 观察到的实际输出 / 行为 | 判定结果 |
|---|---|---|---|
| **1. 完整性与权限检查** | `icacls GradiusIiiSNESRecomp.exe` | 权限显示标准 Medium Integrity 权限与正常继承 ACL，无沙盒提升或特殊提权 | **PASS** |
| **2. 无 ROM 首次启动** | 干净解压后直接执行，设置 `LNG_SMOKE_FRAMES=25` | 启动器 GUI 窗口正常初始化，加载 LatoLatin / DirectWrite 字体，25 帧渲染后优雅退出 (ExitCode 0) | **PASS** |
| **3. 错误 ROM 自动拦截 (3a)** | 注入 512KB 伪造全 0 ROM，配置 `SkipLauncher=1` | Host 立即识别哈希不匹配并输出：`mods: plan rejected: The selected ROM does not match this mod catalog target.`，拒绝启动游戏并返回 ExitCode 1 | **PASS** |
| **4. 错误 ROM 启动器交互 (3b)** | 注入伪造 ROM，配置 `SkipLauncher=0` | 启动器 GUI 正常打开并显示警告标志（verdict_bad），阻止直接进入游戏，烟测 25 帧退出 (ExitCode 0) | **PASS** |
| **5. 正确 ROM 识别与直入** | 放置零售原版 ROM，配置 `SkipLauncher=1`，执行 200 帧 | 成功加载 524,288 字节 ROM，初始化 PPU/APU，创建 960x720 窗口，音频设备成功开启 (32040Hz stereo)，稳定运行 200 帧 (60.345 FPS) | **PASS** |
| **6. 即时存档保存与复位验证** | 游戏运行退出触发 `Autosave=1` | `saves/save0.sav` 成功生成 (297,411 字节)，包含完整 65816 CPU、WRAM、PPU、APU 与 60 帧 Rewind 快照环形缓冲区 | **PASS** |
| **7. 即时存档热加载 (Cold Reload)** | 再次启动执行 60 帧，加载 `saves/save0.sav` | 成功恢复到第 200 帧现场，音频平滑恢复（first audio callback 2048 字节），稳定运行 60 帧 (60.702 FPS) | **PASS** |
| **8. `--launcher` 标志覆盖** | 在配置 `SkipLauncher=1` 下带 `--launcher` 参数启动 | 启动器成功覆盖跳过标志，强制弹出图形界面，烟测 25 帧退出 (ExitCode 0) | **PASS** |
| **9. CLI `--help` 命令行规范** | 运行 `GradiusIiiSNESRecomp.exe --help` | 正常打印全部 CLI 参数用法并在 137ms 内干净退出 (ExitCode 0) | **PASS** |

---

## 四、全游戏人工通关与核心体验确认

- **人工通关验收事实**: 用户已亲自对原生重编译版进行完整人工通关，报告：
  - 全流程关卡推进流畅正常。
  - 武器配置（TYPE A/B/C/D 与 EDIT）切换与升级逻辑正常。
  - 各关 Boss 战动作、碰撞与转场完好。
  - 减速与时序真实还原 65816 原版 SlowROM 表现。
  - 音频合成无爆音、断音或通道错位。
- **PC 本地增强功能**:
  - `recomp-ui` 图形启动器支持 ROM 文件选择、SHA-256 校验与设置记忆。
  - 支持键盘全键自定义映射（`keybinds.ini` 与 GUI 界面）。
  - 支持 Xbox / PlayStation / Switch 等通用手柄热插拔。
  - 支持 4:3 与 8:7 画面比例切换及 VSync。
  - 支持 `F7` 实时多槽存档菜单与 `F8` 倒带系统。
  - 支持游戏内按 `L` 键或手柄 `Select+L3` 热键无缝唤出设置启动器。

---

## 五、结论

Gradius III SNESRecomp Phase M3 所有研发、UI 接入、归档打包及中等完整性自动化验收均已 100% 达成。

**PREVIEW_RC_READY_FOR_USER_ACCEPTANCE**
