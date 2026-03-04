#!/bin/bash

# iOS游戏插件注入脚本
# 用于将dylib插件注入到IPA文件中

echo "=== iOS游戏插件注入工具 ==="
echo "作者: Plugin Developer"
echo "版本: 1.0.0"
echo ""

# 检查参数
if [ $# -ne 2 ]; then
    echo "使用方法: $0 <原始IPA路径> <输出IPA路径>"
    echo "示例: $0 game.ipa game_mod.ipa"
    exit 1
fi

ORIGINAL_IPA="$1"
OUTPUT_IPA="$2"
WORK_DIR="$(pwd)/temp_work"
PLUGIN_NAME="GamePlugin.dylib"

# 检查文件是否存在
if [ ! -f "$ORIGINAL_IPA" ]; then
    echo "错误: 找不到原始IPA文件: $ORIGINAL_IPA"
    exit 1
fi

# 创建工作目录
echo "1. 创建工作目录..."
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

# 解压IPA
echo "2. 解压IPA文件..."
cd "$WORK_DIR"
unzip -q "$ORIGINAL_IPA" -d extracted/

# 查找.app文件
echo "3. 查找.app文件..."
APP_PATH=$(find extracted -name "*.app" -type d | head -1)
if [ -z "$APP_PATH" ]; then
    echo "错误: 找不到.app文件"
    exit 1
fi

echo "找到应用: $APP_PATH"

# 复制插件文件
echo "4. 复制插件文件..."
if [ ! -f "../$PLUGIN_NAME" ]; then
    echo "错误: 找不到插件文件: $PLUGIN_NAME"
    echo "请先编译插件: make"
    exit 1
fi

cp "../$PLUGIN_NAME" "$APP_PATH/"

# 修改Info.plist
echo "5. 修改Info.plist..."
INFO_PLIST="$APP_PATH/Info.plist"
if [ -f "$INFO_PLIST" ]; then
    # 备份原始文件
    cp "$INFO_PLIST" "$INFO_PLIST.bak"
    
    # 添加插件加载配置
    /usr/libexec/PlistBuddy -c "Add :GamePluginLoad bool true" "$INFO_PLIST" 2>/dev/null || true
    
    echo "Info.plist已修改"
else
    echo "警告: 找不到Info.plist文件"
fi

# 创建加载脚本
echo "6. 创建插件加载脚本..."
cat > "$APP_PATH/load_plugin.sh" << 'EOF'
#!/bin/bash
# 插件加载脚本

DYLIB_NAME="GamePlugin.dylib"
DYLIB_PATH="$(dirname "$0")/$DYLIB_NAME"

if [ -f "$DYLIB_PATH" ]; then
    echo "正在加载插件: $DYLIB_NAME"
    export DYLD_INSERT_LIBRARIES="$DYLIB_PATH"
else
    echo "警告: 找不到插件文件: $DYLIB_PATH"
fi

# 启动原始应用
exec "$(dirname "$0")/$(basename "$0" .app)" "$@"
EOF

chmod +x "$APP_PATH/load_plugin.sh"

# 重新签名
echo "7. 重新签名应用..."
# 这里使用临时签名，实际使用时需要有效的开发者证书
codesign -f -s - "$APP_PATH/$PLUGIN_NAME" 2>/dev/null || echo "警告: 插件签名失败"
codesign -f -s - "$APP_PATH" 2>/dev/null || echo "警告: 应用签名失败"

# 重新打包IPA
echo "8. 重新打包IPA..."
cd extracted
zip -r -q "../$OUTPUT_IPA" .
cd ..

# 清理工作目录
echo "9. 清理工作目录..."
cd ..
rm -rf "$WORK_DIR"

echo ""
echo "=== 插件注入完成 ==="
echo "输出文件: $OUTPUT_IPA"
echo ""
echo "安装方法:"
echo "1. 使用AltStore或Sideloadly安装IPA"
echo "2. 确保设备已越狱或使用开发者证书"
echo "3. 首次打开应用时会显示悬浮窗"
echo ""
echo "插件功能:"
echo "- 圆形悬浮窗图标，可拖拽移动"
echo "- 点击展开/收回功能面板"
echo "- 卡密验证系统"
echo "- 游戏功能菜单（无敌、加速、自动点击）"