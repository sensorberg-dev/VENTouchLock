#import "VENTouchLockEnterPasscodeViewController.h"
#import "VENTouchLockPasscodeView.h"
#import "VENTouchLock.h"
#import <tolo/Tolo.h>

NSString *const VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttempts = @"VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttempts";

@implementation VENTouchLockEnterPasscodeViewController

#pragma mark - Class Methods

+ (void)resetPasscodeAttemptHistory
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults removeObjectForKey:VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttempts];
    [standardDefaults synchronize];
}


#pragma mark - Instance Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [self.touchLock appearance].enterPasscodeViewControllerTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passcodeView.title = [self.touchLock appearance].enterPasscodeInitialLabelText;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    VENTouchLockEventUnlockPasscode *event = [VENTouchLockEventUnlockPasscode new];
    PUBLISH(event);
}

- (void)enteredPasscode:(NSString *)passcode
{
    [super enteredPasscode:passcode];
    if ([self.touchLock isPasscodeValid:passcode]) {
        [[self class] resetPasscodeAttemptHistory];
        [self finishWithResult:YES animated:YES];
    }
    else {
        [self.passcodeView shakeAndVibrateCompletion:^{
            self.passcodeView.title = [self.touchLock appearance].enterPasscodeIncorrectLabelText;
            [self clearPasscode];
            if ([self parentSplashViewController]) {
                [self recordIncorrectPasscodeAttempt];
            }
        }];
        VENTouchLockEventUnlockPasscodeIncorrect *event = [VENTouchLockEventUnlockPasscodeIncorrect new];
        PUBLISH(event);
    }
}

- (void)userTappedCancel
{
    [super userTappedCancel];
    VENTouchLockEventUnlockPasscodeResult *event = [VENTouchLockEventUnlockPasscodeResult new];
    event.userCanceled = YES;
    PUBLISH(event);
}

- (void)finishWithResult:(BOOL)success animated:(BOOL)animated
{
    [super finishWithResult:success animated:animated];
    VENTouchLockEventUnlockPasscodeResult *event = [VENTouchLockEventUnlockPasscodeResult new];
    event.success = success;
    PUBLISH(event);
}

- (void)recordIncorrectPasscodeAttempt
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger numberOfAttemptsSoFar = [standardDefaults integerForKey:VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttempts];
    numberOfAttemptsSoFar ++;
    [standardDefaults setInteger:numberOfAttemptsSoFar forKey:VENTouchLockEnterPasscodeUserDefaultsKeyNumberOfConsecutivePasscodeAttempts];
    [standardDefaults synchronize];
    if (numberOfAttemptsSoFar >= [self.touchLock passcodeAttemptLimit]) {
        [self callExceededLimitActionBlock];
    }
}

- (void)callExceededLimitActionBlock
{
    VENTouchLockEventUnlockPasscodeAttemptLimitExceeded *event = [VENTouchLockEventUnlockPasscodeAttemptLimitExceeded new];
    PUBLISH(event);

    [[self parentSplashViewController] dismissWithUnlockSuccess:NO
                                                     unlockType:VENTouchLockSplashViewControllerUnlockTypeNone
                                                       animated:NO];
    
}

- (VENTouchLockSplashViewController *)parentSplashViewController
{
    VENTouchLockSplashViewController *splashViewController = nil;
    UIViewController *presentingViewController = self.presentingViewController;
    if (self.touchLock.appearance.splashShouldEmbedInNavigationController) {
        UIViewController *rootViewController = ([presentingViewController isKindOfClass:[UINavigationController class]]) ? [((UINavigationController *)presentingViewController).viewControllers firstObject] : nil;
        if ([rootViewController isKindOfClass:[VENTouchLockSplashViewController class]]) {
            splashViewController = (VENTouchLockSplashViewController *)rootViewController;
        }
    }
    else if ([presentingViewController isKindOfClass:[VENTouchLockSplashViewController class]]) {
        splashViewController = (VENTouchLockSplashViewController *)presentingViewController;
    }
    return splashViewController;
}

@end
