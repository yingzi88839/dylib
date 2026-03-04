# iOS 游戏插件

这是一个 iOS 游戏插件项目，包含悬浮窗功能、卡密验证和游戏修改功能。

## 功能特点

- 🎯 圆形悬浮窗，可拖拽移动
- 🔐 卡密验证系统
- 🎮 游戏功能菜单（无敌、加速、自动点击）

## 使用方法

1. 编译项目生成 `GamePlugin.dylib`
2. 使用 `inject_plugin.sh` 注入到游戏 IPA
3. 安装修改后的 IPA 到设备

## 文件说明

- `GamePlugin.h/m` - 主类实现
- `Tweak.x` - 插件注入逻辑
- `Makefile` - 编译配置
- `inject_plugin.sh` - IPA 注入脚本

## 编译

```bash
make
```

## 卡密

测试卡密：
- `12345-67890-ABCDE`
- `TEST-KEY-2024`
- `VIP-USER-001`
