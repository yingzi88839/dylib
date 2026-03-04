#import "GamePlugin.h"
#import <substrate.h>

%hook UIApplication

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    
    // 延迟显示悬浮窗，确保应用完全启动
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[GamePlugin sharedInstance] showFloatWindow];
    });
}

%end

%hook UIViewController

- (void)viewDidLoad {
    %orig;
    
    // 确保悬浮窗始终在最上层
    dispatch_async(dispatch_get_main_queue(), ^{
        GamePlugin *plugin = [GamePlugin sharedInstance];
        if (plugin.floatWindow) {
            [plugin.floatWindow makeKeyAndVisible];
        }
    });
}

%end