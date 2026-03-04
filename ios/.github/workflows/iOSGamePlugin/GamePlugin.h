#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <substrate.h>

@interface GamePlugin : NSObject
@property (nonatomic, strong) UIWindow *floatWindow;
@property (nonatomic, strong) UIButton *floatButton;
@property (nonatomic, strong) UIView *mainPanel;
@property (nonatomic, strong) UITextField *keyInputField;
@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL isVerified;

+ (instancetype)sharedInstance;
- (void)showFloatWindow;
- (void)hideFloatWindow;
- (void)togglePanel;
- (void)verifyKey:(NSString *)key;
@end