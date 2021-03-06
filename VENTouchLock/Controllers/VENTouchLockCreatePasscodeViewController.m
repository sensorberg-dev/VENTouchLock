#import "VENTouchLockCreatePasscodeViewController.h"
#import "VENTouchLockPasscodeView.h"
#import "VENTouchLock.h"
#import <tolo/Tolo.h>

static CGFloat const VENTouchLockCreatePasscodeViewControllerAnimationDuration = 0.2;

@interface VENTouchLockCreatePasscodeViewController ()
@property (strong, nonatomic) NSString *firstPasscode;
@end

@implementation VENTouchLockCreatePasscodeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [self.touchLock appearance].createPasscodeViewControllerTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passcodeView.title = [self.touchLock appearance].createPasscodeInitialLabelText;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    VENTouchLockEventCreatePasscode *event = [VENTouchLockEventCreatePasscode new];
    event.inputType = VENTouchLockPassCodeInputTypeFirst;
    PUBLISH(event);
}
- (void)enteredPasscode:(NSString *)passcode;
{
    [super enteredPasscode:passcode];
    if (self.firstPasscode) {
        if ([passcode isEqualToString:self.firstPasscode]) {
            [self.touchLock setPasscode:passcode];
            [self finishWithResult:YES animated:YES];
        }
        else {
            [self.passcodeView shakeAndVibrateCompletion:^{
                self.firstPasscode = nil;
                [self showFirstPasscodeView];
            }];
        }
    }
    else {
        self.firstPasscode = passcode;
        [self showConfirmPasscodeView];
    }
}

- (void)userTappedCancel
{
    [super userTappedCancel];
    VENTouchLockEventCreatePasscodeResult *event = [VENTouchLockEventCreatePasscodeResult new];
    event.userCanceled = YES;
    PUBLISH(event);
}

- (void)finishWithResult:(BOOL)success animated:(BOOL)animated
{
    [super finishWithResult:success animated:animated];
    VENTouchLockEventCreatePasscodeResult *event = [VENTouchLockEventCreatePasscodeResult new];
    event.success = success;
    PUBLISH(event);
}

- (void)showConfirmPasscodeView
{
    VENTouchLockPasscodeView *firstPasscodeView = self.passcodeView;
    CGFloat passcodeViewWidth = CGRectGetWidth(firstPasscodeView.frame);
    CGRect confirmInitialFrame = CGRectMake(passcodeViewWidth,
                                            CGRectGetMinY(firstPasscodeView.frame),
                                            passcodeViewWidth,
                                            CGRectGetHeight(firstPasscodeView.frame));
    CGRect confirmEndFrame = firstPasscodeView.frame;
    CGRect firstEndFrame = CGRectMake(-passcodeViewWidth,
                                      CGRectGetMinY(firstPasscodeView.frame),
                                      passcodeViewWidth,
                                      CGRectGetHeight(firstPasscodeView.frame));
    VENTouchLockAppearance *appearance = [self.touchLock appearance];
    NSString *confirmPasscodeTitle = appearance.createPasscodeConfirmLabelText;
    VENTouchLockPasscodeView *confirmPasscodeView = [[VENTouchLockPasscodeView alloc]
                                                     initWithTitle:confirmPasscodeTitle
                                                     frame:confirmInitialFrame
                                                     titleColor:appearance.passcodeViewControllerTitleColor
                                                     titleFont:appearance.passcodeViewControllerTitleFont
                                                     characterColor:appearance.passcodeViewControllerCharacterColor
                                                     emptyCharacterColor:appearance.passcodeViewControllerEmptyCharacterColor];
    confirmPasscodeView.verticalGapTitleAndCharacter = appearance.passcodeViewVerticalGapTitleAndCharacter;
    [confirmPasscodeView setLogoImage:appearance.passcodeViewControllerLogoImage];
    [self.view addSubview:confirmPasscodeView];
    [UIView animateWithDuration: VENTouchLockCreatePasscodeViewControllerAnimationDuration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         firstPasscodeView.frame = firstEndFrame;
                         confirmPasscodeView.frame = confirmEndFrame;
                     }
                     completion:^(BOOL finished) {
                         [firstPasscodeView removeFromSuperview];
                         self.passcodeView = confirmPasscodeView;
                     }];
    VENTouchLockEventCreatePasscode *event = [VENTouchLockEventCreatePasscode new];
    event.inputType = VENTouchLockPassCodeInputTypeConfirm;
    PUBLISH(event);
}

- (void)showFirstPasscodeView
{
    VENTouchLockPasscodeView *confirmPasscodeView = self.passcodeView;
    CGFloat passcodeViewWidth = CGRectGetWidth(confirmPasscodeView.frame);
    CGRect firstInitialFrame = CGRectMake(-passcodeViewWidth,
                                          CGRectGetMinY(confirmPasscodeView.frame),
                                          passcodeViewWidth,
                                          CGRectGetHeight(confirmPasscodeView.frame));
    CGRect firstEndFrame = confirmPasscodeView.frame;
    CGRect confirmEndFrame = CGRectMake(passcodeViewWidth,
                                        CGRectGetMinY(confirmPasscodeView.frame),
                                        passcodeViewWidth,
                                        CGRectGetHeight(confirmPasscodeView.frame));
    VENTouchLockAppearance *appearance = [self.touchLock appearance];
    NSString *firstPasscodeTitle = appearance.createPasscodeMismatchedLabelText;
    VENTouchLockPasscodeView *firstPasscodeView = [[VENTouchLockPasscodeView alloc] initWithTitle:firstPasscodeTitle
                                                                                            frame:firstInitialFrame
                                                                                       titleColor:appearance.passcodeViewControllerTitleColor
                                                                                        titleFont:appearance.passcodeViewControllerTitleFont
                                                                                   characterColor:appearance.passcodeViewControllerCharacterColor
                                                                              emptyCharacterColor:appearance.passcodeViewControllerEmptyCharacterColor];
    firstPasscodeView.verticalGapTitleAndCharacter = appearance.passcodeViewVerticalGapTitleAndCharacter;
    [self.view addSubview:firstPasscodeView];
    [UIView animateWithDuration: VENTouchLockCreatePasscodeViewControllerAnimationDuration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         confirmPasscodeView.frame = confirmEndFrame;
                         firstPasscodeView.frame = firstEndFrame;
                     }
                     completion:^(BOOL finished) {
                         [confirmPasscodeView removeFromSuperview];
                         self.passcodeView = firstPasscodeView;
                     }];
    VENTouchLockEventCreatePasscode *event = [VENTouchLockEventCreatePasscode new];
    event.inputType = VENTouchLockPassCodeInputTypeFirst;
    PUBLISH(event);
}

@end
