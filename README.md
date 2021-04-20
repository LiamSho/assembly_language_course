# 微机原理与接口技(汇编语言) 实验课代码

这是宁波大学微机原理与接口技术实验课代码

当然，不保证和你的题目一样

## 运行环境

- DOSBox v0.74-3-3
- MASM v6.11
- Visual Studio Code (MASM/TASM插件)

## Visual Studio Code 开发环境

1. 下载 [Visual Studio Code](https://code.visualstudio.com/)
2. 打开 Vscode，在左侧插件窗口搜索安装 [MASM/TASM](https://marketplace.visualstudio.com/items?itemName=xsro.masm-tasm) 插件(打开网页点安装也可)，有需要的话也可以搜索安装中文语言包
3. `Linux/macOS` 非 Windows 用户需要下载安装 [DOSBox](https://www.dosbox.com/download.php?main=1) ，使用 `Apple Silicon` 的 Mac 需要安装 [Rosetta 2](https://support.apple.com/zh-cn/HT211861)
4. 从左下角的按钮打开 vscode 设置，找到 `插件 -> MASM/TASM` ,选择 `MASM` 作为宏汇编环境，`DOSBox` 作为运行环境
5. 打开一个 `ASM` 文件，右键后可选择 `打开DOSbox模拟器` `运行汇编程序` `调试汇编程序`，不推荐直接选择调试，默认调试工具为 DEBUG 而不是 TD
6. 更多关于 `MASM/TASM` 插件，访问 [官方文档](https://gitee.com/dosasm/masm-tasm/)

## 许可证

本仓库使用 [DO WHAT THE F**K YOU WANT TO PUBLIC LICENSE(WTFPL, 你TM爱干啥干啥)](./LICENSE) 许可证授权