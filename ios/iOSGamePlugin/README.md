# iOS游戏插件使用说明

## 项目结构
```
iOSGamePlugin/
├── Makefile              # 编译配置文件
├── control              # 插件信息
├── Tweak.x             # 插件注入逻辑
├── GamePlugin.h        # 主类头文件
├── GamePlugin.m        # 主类实现
└── inject_plugin.sh    # IPA注入脚本
```

## 功能特点

### 1. 悬浮窗功能
- **圆形图标**: 直径60px的圆形悬浮按钮
- **可拖拽**: 支持手指拖拽移动位置
- **自动贴边**: 智能吸附屏幕边缘
- **展开/收回**: 点击切换显示状态

### 2. 卡密验证
- **输入验证**: 支持卡密输入和验证
- **预设卡密**: 
  - `12345-67890-ABCDE`
  - `TEST-KEY-2024` 
  - `VIP-USER-001`
- **验证成功**: 自动切换到功能菜单

### 3. 游戏功能
- **无敌模式**: 游戏角色无敌状态
- **加速模式**: 游戏速度加快
- **自动点击**: 自动点击功能

## 编译方法

### 1. 环境要求
- macOS系统
- Xcode命令行工具
- Theos开发环境
- iOS SDK

### 2. 编译步骤
```bash
# 安装Theos（如果未安装）
bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"

# 编译插件
make

# 清理编译文件
make clean
```

### 3. 安装到设备
```bash
# 通过SSH安装到越狱设备
make install

# 或者手动复制到设备
scp .theos/obj/GamePlugin.dylib user@device-ip:/Library/MobileSubstrate/DynamicLibraries/
```

## IPA注入方法

### 1. 准备文件
- 原始游戏IPA文件
- 编译好的GamePlugin.dylib插件

### 2. 运行注入脚本
```bash
# 给脚本执行权限
chmod +x inject_plugin.sh

# 执行注入
./inject_plugin.sh 原始游戏.ipa 修改版游戏.ipa
```

### 3. 安装修改版IPA
- 使用AltStore安装
- 使用Sideloadly安装
- 使用Xcode安装到开发设备

## 使用说明

### 1. 首次启动
- 应用启动2秒后自动显示悬浮窗
- 点击悬浮窗显示卡密输入界面
- 输入有效卡密后进入功能菜单

### 2. 悬浮窗操作
- **单击**: 展开/收回功能面板
- **长按拖拽**: 移动悬浮窗位置
- **智能贴边**: 靠近屏幕边缘时自动吸附

### 3. 功能使用
- 验证成功后显示功能菜单
- 点击对应功能按钮激活游戏修改
- 功能状态会在按钮上显示

## 自定义开发

### 1. 修改卡密验证
在`GamePlugin.m`中修改`verifyKey:`方法：
```objc
- (void)verifyKey:(NSString *)key {
    // 连接服务器验证
    NSString *serverUrl = @"https://your-server.com/verify";
    // 添加网络请求逻辑
}
```

### 2. 添加新功能
在`setupFunctionPanel`方法中添加新按钮：
```objc
UIButton *newFeatureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
// 配置按钮属性
[newFeatureBtn addTarget:self action:@selector(newFeatureTapped) forControlEvents:UIControlEventTouchUpInside];
```

### 3. 修改悬浮窗样式
在`setupFloatWindow`方法中修改外观：
```objc
// 修改颜色
self.floatButton.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.8];

// 修改大小
self.floatButton.frame = CGRectMake(0, 0, 80, 80);
self.floatButton.layer.cornerRadius = 40;
```

## 注意事项

### 1. 兼容性
- 支持iOS 13.0及以上版本
- 支持arm64和arm64e架构
- 需要越狱设备或开发者证书

### 2. 安全性
- 卡密验证建议连接服务器
- 不要在代码中硬敏感信息
- 使用代码混淆保护逻辑

### 3. 调试
- 使用Xcode控制台查看日志
- 通过iOS系统日志调试
- 使用断点调试功能逻辑

## 常见问题

### Q: 悬浮窗不显示？
A: 检查应用权限和窗口级别设置

### Q: 卡密验证失败？
A: 确认卡密格式和验证逻辑

### Q: 功能无效？
A: 检查游戏内存修改逻辑

### Q: 编译失败？
A: 确认Theos环境和SDK版本

## 更新日志

### v1.0.0
- ✨ 初始版本发布
- 🎯 基础悬浮窗功能
- 🔐 卡密验证系统
- 🎮 游戏功能菜单
- 📱 支持拖拽移动
- 🔄 展开/收回动画