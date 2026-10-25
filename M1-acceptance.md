# Gradius III SNESRecomp — Phase M1 Acceptance Report

## 一、检查点状态
**CHECKPOINT: `FIRST_STAGE_PLAYABLE`**

本轮完成 Gradius III (USA) 原版 ROM 的静态重编译（AOT）、Windows x64 原生可执行程序编译与运行验证，成功通过标题、模式选择、武器选择界面，并进入第一关实际游玩操作。

---

## 二、ROM 身份与硬件基线
- **ROM 文件**: `Gradius III (USA).sfc`
- **文件大小**: 524,288 字节 (512 KiB)
- **SHA-256**: `93da752a0c76167d0907efa832367e5d14aab8e835b864f345c386071a9af718`
- **CRC32**: `cd973979`
- **ROM 映射**: LoROM (2.68 MHz SlowROM 原版时序)
- **卡带硬件**: SHVC-1A0N-01 (无协处理器 `coprocessor=none`, 无电池 SRAM)
- **时序与减速**: 100% 保持原版 65816 / PPU / APU 时序，未加入 SA-1、FastROM 或跳帧 Hack。

---

## 三、静态转译与编译
- **SNESRecomp 版本**: Commit `82b4acbf909095184cee32a20cf6f78557598234`
- **AOT 生成统计**:
  - 生成 381 个函数变体（363 个原生 AOT 变体，18 个复杂间接分支 LLE 回退变体）。
  - 函数边界自动识别，Reset 入口 `$00:8000` 与 NMI 入口 `$00:8223` 均正确捕获。
- **关键突破 (HLE 解决转场死循环)**:
  - 游戏屏幕转场子程序 `$00:86CD` 原在 NMI 内轮询等待下一场 VBLANK 标志。在同步帧调度架构下会陷入死循环。
  - 通过在 `recomp/bank00.cfg` 声明 `hle_func 86CD HleWaitVBlank`，并在 `src/gen_stubs.c` 中准确实现硬件握手与屏幕亮度/DMA 清理，完美解除阻塞。
- **构建环境**:
  - MinGW-w64 GCC 14.2.0 + Ninja 1.12.1 + SDL2 (2.32.8)
  - 并行度: `-j2`，编译一次通过，产出 `GradiusIiiSNESRecomp.exe` (5,919,803 字节)。

---

## 四、运行时与最小可玩性验证
- **可执行程序**: `D:\Project\GameRecomp\GradiusIIIRecomp\build\GradiusIiiSNESRecomp.exe`
- **启动与运行**:
  - 窗口: 960x720 普通 SDL 窗口 (原生 4:3 比例)。
  - 音频: 32000Hz 立体声打开，SPC700/APU 双向端口正常轮询握手并持续发声。
  - 帧率: 54.6 ~ 60.0 FPS。
- **阶段流转与按键验证**:
  1. **开场与标题 (Frame 0 ~ 550)**:
     - KONAMI Logo 与开场卷动正常，标题画面星空与 "Gradius III" Logo 正常渲染。
  2. **模式选择 (Frame 550 ~ 770)**:
     - 按 START 键唤出 "1 PLAYER / 2 PLAYERS / OPTIONS" 菜单，再次按 START 确认单人模式。
  3. **武器选择 (Frame 770 ~ 1000)**:
     - 成功进入 Weapon Select 画面，显示 TYPE A / B / C / EDIT 与武器图标。
     - 按控制器 A 键选择 TYPE A，再次按 A 键确认，触发黑屏淡出过渡。
  4. **第一关加载与游玩 (Frame 1000 ~ 1829+)**:
     - 玩家飞船 Vic Viper 正常显示在屏幕上 (`Y=104, X=112`)。
     - 背景自然横向卷动：BG1 卷动至 `hscroll=357`，BG2 视差卷动至 `hscroll=178`。
     - 敌机编队正常生成与飞入。
     - 玩家输入测试：按下 `Right + B`、`Up + B`、`Down + B`，玩家飞船顺畅移动至 `X=172` 并开火射击。
- **代表性截图保留于**:
  - `diagnostics/01_title_screen.bmp` (标题画面)
  - `diagnostics/02_weapon_select.bmp` (武器选择画面)
  - `diagnostics/03_stage1_action.bmp` (第一关飞船移动与战斗画面)

---

## 五、安全与工程基线
- **同级目录隔离**: 未修改 `PilotwingsRecomp`, `SuperMarioKartRecomp`, `snesrecomp-main` 等任何同级目录。
- **系统安全**: 未修改 `D:\Project\GameRecomp` 权限/完整性级别。
- **代码库规范**: 未向 Git 提交 ROM、AOT 生成的 C 源码、编译产物、存档或临时 Dump。
- **磁盘占用**: 项目总占用空间约 63 MB。
- **无 Push / Release**: 仅在本地提交，等待用户人工试玩。
