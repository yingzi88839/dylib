#import "GamePlugin.h"
#import <objc/runtime.h>

@implementation GamePlugin

+ (instancetype)sharedInstance {
    static GamePlugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isExpanded = NO;
        _isVerified = NO;
        [self setupFloatWindow];
    }
    return self;
}

- (void)setupFloatWindow {
    // 创建悬浮窗
    self.floatWindow = [[UIWindow alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
    self.floatWindow.windowLevel = UIWindowLevelStatusBar + 1;
    self.floatWindow.backgroundColor = [UIColor clearColor];
    self.floatWindow.hidden = NO;
    
    // 创建圆形按钮
    self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatButton.frame = CGRectMake(0, 0, 60, 60);
    self.floatButton.layer.cornerRadius = 30;
    self.floatButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.8];
    self.floatButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.floatButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.floatButton.layer.shadowOpacity = 0.3;
    self.floatButton.layer.shadowRadius = 3;
    
    // 设置按钮图标（使用emoji作为示例）
    [self.floatButton setTitle:@"🎮" forState:UIControlStateNormal];
    [self.floatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.floatButton.titleLabel.font = [UIFont systemFontOfSize:24];
    
    [self.floatButton addTarget:self action:@selector(floatButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.floatWindow addSubview:self.floatButton];
    
    // 创建功能面板
    [self setupMainPanel];
    
    // 添加拖拽手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.floatButton addGestureRecognizer:panGesture];
}

- (void)setupMainPanel {
    self.mainPanel = [[UIView alloc] initWithFrame:CGRectMake(-150, 70, 200, 300)];
    self.mainPanel.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
    self.mainPanel.layer.cornerRadius = 10;
    self.mainPanel.hidden = YES;
    
    // 创建标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 30)];
    titleLabel.text = @"游戏插件";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.mainPanel addSubview:titleLabel];
    
    // 创建卡密输入框
    self.keyInputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, 180, 40)];
    self.keyInputField.placeholder = @"请输入卡密";
    self.keyInputField.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    self.keyInputField.textColor = [UIColor whiteColor];
    self.keyInputField.layer.cornerRadius = 5;
    self.keyInputField.borderStyle = UITextBorderStyleNone;
    self.keyInputField.font = [UIFont systemFontOfSize:14];
    self.keyInputField.tag = 1; // 用于识别
    
    // 添加内边距
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    self.keyInputField.leftView = paddingView;
    self.keyInputField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.mainPanel addSubview:self.keyInputField];
    
    // 创建验证按钮
    self.verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.verifyButton.frame = CGRectMake(10, 100, 180, 40);
    [self.verifyButton setTitle:@"验证卡密" forState:UIControlStateNormal];
    self.verifyButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    self.verifyButton.layer.cornerRadius = 5;
    self.verifyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.verifyButton addTarget:self action:@selector(verifyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:self.verifyButton];
    
    [self.floatWindow addSubview:self.mainPanel];
}

- (void)floatButtonTapped {
    if (!self.isVerified) {
        // 如果未验证，显示卡密输入界面
        self.mainPanel.hidden = !self.mainPanel.hidden;
    } else {
        // 已验证，显示功能界面
        [self togglePanel];
    }
}

- (void)verifyButtonTapped {
    NSString *key = self.keyInputField.text;
    if (key.length > 0) {
        [self verifyKey:key];
    } else {
        [self showAlert:@"请输入卡密"];
    }
}

- (void)verifyKey:(NSString *)key {
    // 简单的卡密验证逻辑（实际项目中应该连接服务器验证）
    NSArray *validKeys = @[@"12345-67890-ABCDE", @"TEST-KEY-2024", @"VIP-USER-001"];
    
    if ([validKeys containsObject:key]) {
        self.isVerified = YES;
        self.mainPanel.hidden = YES;
        [self showAlert:@"卡密验证成功！"];
        
        // 切换到功能界面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupFunctionPanel];
        });
    } else {
        [self showAlert:@"卡密无效，请重新输入"];
    }
}

- (void)setupFunctionPanel {
    // 清除现有内容，创建功能界面
    for (UIView *subview in self.mainPanel.subviews) {
        [subview removeFromSuperview];
    }
    
    // 功能标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 30)];
    titleLabel.text = @"功能菜单";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.mainPanel addSubview:titleLabel];
    
    // 功能按钮1 - 无敌模式
    UIButton *godModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    godModeBtn.frame = CGRectMake(10, 50, 180, 35);
    [godModeBtn setTitle:@"无敌模式" forState:UIControlStateNormal];
    godModeBtn.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    godModeBtn.layer.cornerRadius = 5;
    godModeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [godModeBtn addTarget:self action:@selector(godModeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:godModeBtn];
    
    // 功能按钮2 - 加速
    UIButton *speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speedBtn.frame = CGRectMake(10, 95, 180, 35);
    [speedBtn setTitle:@"加速模式" forState:UIControlStateNormal];
    speedBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    speedBtn.layer.cornerRadius = 5;
    speedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [speedBtn addTarget:self action:@selector(speedModeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:speedBtn];
    
    // 功能按钮3 - 自动点击
    UIButton *autoClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoClickBtn.frame = CGRectMake(10, 140, 180, 35);
    [autoClickBtn setTitle:@"自动点击" forState:UIControlStateNormal];
    autoClickBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:1.0];
    autoClickBtn.layer.cornerRadius = 5;
    autoClickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [autoClickBtn addTarget:self action:@selector(autoClickTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainPanel addSubview:autoClickBtn];
    
    self.mainPanel.hidden = NO;
}

- (void)togglePanel {
    self.isExpanded = !self.isExpanded;
    
    if (self.isExpanded) {
        // 展开面板
        [UIView animateWithDuration:0.3 animations:^{
            self.mainPanel.hidden = NO;
        }];
    } else {
        // 收回面板
        [UIView animateWithDuration:0.3 animations:^{
            self.mainPanel.hidden = YES;
        }];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    static CGPoint originalCenter;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        originalCenter = self.floatWindow.center;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.floatWindow];
        CGPoint newCenter = CGPointMake(originalCenter.x + translation.x, originalCenter.y + translation.y);
        
        // 限制在屏幕范围内
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        newCenter.x = MAX(30, MIN(screenWidth - 30, newCenter.x));
        newCenter.y = MAX(30, MIN(screenHeight - 30, newCenter.y));
        
        self.floatWindow.center = newCenter;
    }
}

- (void)showAlert:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" 
                                                                     message:message 
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        [topController presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - 功能按钮事件

- (void)godModeTapped {
    [self showAlert:@"无敌模式已开启"];
    // 这里添加具体的游戏修改逻辑
}

- (void)speedModeTapped {
    [self showAlert:@"加速模式已开启"];
    // 这里添加具体的游戏修改逻辑
}

- (void)autoClickTapped {
    [self showAlert:@"自动点击已开启"];
    // 这里添加具体的游戏修改逻辑
}

@end