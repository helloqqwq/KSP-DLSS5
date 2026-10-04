# KSP-DLSS5

给《坎巴拉太空计划》(Kerbal Space Program) 加上 **NVIDIA DLSS 5 神经渲染**。

KSP 是老 Unity 引擎（2019.4 / DirectX 11），本身没有任何 DLSS 支持。这个包用
[ReShade](https://reshade.me) + [DLSS5-Feeder](https://github.com/jlrouzies-fr/DLSS5-Feeder)
在游戏外部合成一份 DLSS 契约，把颜色、深度和运动矢量喂给 NVIDIA 的神经渲染模型，
让 DLSS 5 的神经网络作用在 KSP 的画面上（提升光照与材质）。

---

## 下载

**完整包在 [Releases](https://github.com/helloqqwq/KSP-DLSS5/releases/latest) 里**
（`KSP-DLSS5.zip`，约 148 MB）。

> 本仓库只放文档、脚本和小文件。NVIDIA 的两个运行时
> （`nvngx_dlss.dll` 56 MB、`nvngx_dlssnr.dll` 158 MB）超过 GitHub 单文件
> 100 MB 的限制，因此通过 **Release 附件**分发。

---

## 一、一键安装

1. 用 Steam 右键 KSP → 管理 → 浏览本地文件，确认能看到 `KSP_x64.exe`
2. 双击本包里的 **`Install.bat`**
   - 脚本会自动定位 KSP 目录；找不到时，把 KSP 文件夹**拖到 `Install.bat` 上**即可
3. 启动 KSP

想彻底移除，双击 **`Uninstall.bat`**。

> 安装脚本会自动把 KSP 的抗锯齿设为关闭（DLSS 自带抗锯齿，两者不要叠加）。

---

## 二、手动安装：哪个文件放哪

> **重要：所有文件都放进 KSP 的「游戏根目录」，不是 GameData。**
>
> 游戏根目录 = `KSP_x64.exe` 所在的那个文件夹（和 `GameData`、`Ships`、`KSP_x64_Data` 并列）。
>
> 原因：`dxgi.dll` 靠 Windows 的 DLL 加载机制注入，只从 **exe 同目录**读取，
> 放进 `GameData` 不会被加载。

把 `payload\` 里的东西按下面这张表放：

| 包里的文件 | 放到哪里 | 干什么用的 |
|---|---|---|
| `payload\dxgi.dll` | `KSP\dxgi.dll` | ReShade 6.8 注入器（必须和 KSP_x64.exe 同目录） |
| `payload\ReShade.ini` | `KSP\ReShade.ini` | ReShade 配置（目录、快捷键） |
| `payload\ReShadePreset.ini` | `KSP\ReShadePreset.ini` | 预设，启用 `Lumenite_Kernel` + `DLSS5_Feed` |
| `payload\dlss5-feed.addon64` | `KSP\dlss5-feed.addon64` | DLSS5-Feeder 主插件 |
| `payload\renodx-dlss5.addon64` | `KSP\renodx-dlss5.addon64` | 神经渲染消费者 |
| `payload\nvngx_dlss.dll` | `KSP\nvngx_dlss.dll` | NVIDIA DLSS 运行时 |
| `payload\nvngx_dlssnr.dll` | `KSP\nvngx_dlssnr.dll` | NVIDIA 神经渲染模型（RTX 50 专用） |
| `payload\reshade-shaders\` | `KSP\reshade-shaders\` | **整个目录照搬**（shader + 贴图） |

`reshade-shaders\` 目录内部结构（照搬即可，不用改动）：

```
reshade-shaders\
├── Shaders\
│   ├── DLSS5_Feed.fx              把 颜色/深度/运动矢量 交给 feeder
│   ├── lumenite_Kernel.fx         运动矢量 provider（预设用 DLSS5_MV_PROVIDER=3）
│   ├── lumenite_QuantMotion.fx    备选 provider（DLSS5_MV_PROVIDER=4）
│   ├── lumenite_AnamorphicBloom.fx / LSAO / QuantAO / RTAO / SSSR / TRAA
│   ├── ReShade.fxh / ReShadeUI.fxh / DrawText.fxh    ReShade 框架头
│   └── include\                   lumenite 内部头文件（.fxh）
└── Textures\
    └── lumenite_bluenoise256.png
```

---

## 三、怎么用

1. 启动 KSP，进入任意飞行场景
2. 按 **Home** 打开 ReShade 叠加层
3. 确认技法列表里 **`Lumenite_Kernel` 在 `DLSS5_Feed` 上面**，并且两个都打勾
4. 打开 **DLSS 5 Neural Rendering** 面板，确认神经渲染处于开启状态

神经渲染强度可以在那个面板里实时调整，改动会存进 `ReShade.ini`。

---

## 四、系统要求

| 项目 | 要求 |
|---|---|
| GPU | **NVIDIA RTX 50 系列**（神经模型目前仅支持 RTX 50） |
| 驱动 | 616.56 或更新 |
| 系统 | Windows 10 / 11（64 位） |
| KSP | 1.12.x（64 位） |

---

## 五、致谢 / 上游项目

本包只是把下面这些项目**组合并适配到 KSP**，核心工作全部属于它们的作者：

- [DLSS5-Feeder](https://github.com/jlrouzies-fr/DLSS5-Feeder) — jlrouzies-fr，合成 DLSS 契约
- [RenoDX DLSS 5](https://github.com/yumlevi/renodx-dlss-installer) — 神经渲染消费者
- [LumeniteFX](https://github.com/umar-afzaal/LumeniteFX) — umar-afzaal，运动矢量 provider
- [ReShade](https://reshade.me) — crosire，注入框架
- NVIDIA DLSS 运行时（`nvngx_dlss.dll` / `nvngx_dlssnr.dll`）

使用请遵守各上游项目的许可。

---

## 六、卸载

双击 `Uninstall.bat`，或按第二节的表格手动删掉这些文件和 `reshade-shaders\` 目录。
KSP 本体不会被改动。
