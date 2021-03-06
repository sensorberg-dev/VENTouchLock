#import "VENTouchLockPasscodeViewController.h"
#import "VENTouchLockPasscodeView.h"
#import "VENTouchLockPasscodeCharacterView.h"
#import "UIViewController+VENTouchLock.h"
#import "VENTouchLock.h"

static const NSInteger VENTouchLockViewControllerPasscodeLength = 4;

@interface VENTouchLockPasscodeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *invisiblePasscodeField;
@property (assign, nonatomic) BOOL shouldIgnoreTextFieldDelegateCalls;

@end

@implementation VENTouchLockPasscodeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _touchLock = [VENTouchLock sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    self.view.backgroundColor = [self.touchLock appearance].passcodeViewControllerBackgroundColor;
    [self configureInvisiblePasscodeField];
    [self configureNavigationItems];
    [self configurePasscodeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureBackgroundImage];
    [self configureLogoImage];
    
    if (![self.invisiblePasscodeField isFirstResponder]) {
        [self.invisiblePasscodeField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.invisiblePasscodeField isFirstResponder]) {
        [self.invisiblePasscodeField resignFirstResponder];
    }
}

- (void)configureBackgroundImage
{
    if (self.touchLock.appearance.passcodeViewControllerBackgroundImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.touchLock.appearance.passcodeViewControllerBackgroundImage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        CGRect frame = self.view.frame;
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        imageView.frame = CGRectMake((width - (width * self.touchLock.appearance.passcodeViewControllerBackgroundImageWidthRatio))/2,
                                     0,
                                     width * [VENTouchLock sharedInstance].appearance.passcodeViewControllerBackgroundImageWidthRatio,
                                     height * [VENTouchLock sharedInstance].appearance.passcodeViewControllerBackgroundImageHeightRatio);
        [self.view addSubview:imageView];
        [self.view sendSubviewToBack:imageView];
    }
}

- (void)configureLogoImage
{
    [self.passcodeView setLogoImage:[VENTouchLock sharedInstance].appearance.passcodeViewControllerLogoImage];
}

- (void)configureInvisiblePasscodeField
{
    self.invisiblePasscodeField = [[UITextField alloc] init];
    self.invisiblePasscodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.invisiblePasscodeField.secureTextEntry = YES;
    self.invisiblePasscodeField.keyboardAppearance = self.touchLock.appearance.passcodeViewControllerKeyboardAppearance;
    self.invisiblePasscodeField.delegate = self;
    [self.invisiblePasscodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.invisiblePasscodeField];
}

- (void)configureNavigationItems
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self.touchLock appearance].cancelBarButtonItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(userTappedCancel)];
}

- (void)configurePasscodeView
{
    VENTouchLockPasscodeView *passcodeView = [[VENTouchLockPasscodeView alloc] init];
    passcodeView.titleColor = self.touchLock.appearance.passcodeViewControllerTitleColor;
    passcodeView.titleFont = self.touchLock.appearance.passcodeViewControllerTitleFont;
    passcodeView.verticalGapTitleAndCharacter = self.touchLock.appearance.passcodeViewVerticalGapTitleAndCharacter;
    passcodeView.characterColor = self.touchLock.appearance.passcodeViewControllerCharacterColor;
    passcodeView.emptyCharacterColor = self.touchLock.appearance.passcodeViewControllerEmptyCharacterColor;
    
    [self.view addSubview:passcodeView];
    self.passcodeView = passcodeView;
    self.passcodeView.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.touchLock.appearance.statusBarStyle;
}

- (void)userTappedCancel
{
    // fire cancel event
    if (self.willFinishWithResult) {
        self.willFinishWithResult(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishWithResult:(BOOL)success animated:(BOOL)animated
{
    [self.invisiblePasscodeField resignFirstResponder];
    
    // fire finish event
    if (self.willFinishWithResult) {
        self.willFinishWithResult(success);
    } else {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

- (UINavigationController *)embeddedInNavigationController
{
    return [super ventouchlock_embeddedInNavigationControllerWithNavigationBarClass:self.touchLock.appearance.navigationBarClass];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect newKeyboardFrame = [(NSValue *)[notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat passcodeLockViewHeight = CGRectGetHeight(self.view.frame) - CGRectGetHeight(newKeyboardFrame);
    if (passcodeLockViewHeight >= CGRectGetHeight(self.view.frame) * 0.6f) {
        passcodeLockViewHeight = CGRectGetHeight(self.view.frame);
    }
    CGFloat passcodeLockViewWidth = CGRectGetWidth(self.view.frame);
    self.passcodeView.frame = CGRectMake(0, 0, passcodeLockViewWidth, passcodeLockViewHeight);
}

- (void)enteredPasscode:(NSString *)passcode
{
    self.shouldIgnoreTextFieldDelegateCalls = NO;
}

- (void)clearPasscode
{
    UITextField *textField = self.invisiblePasscodeField;
    textField.text = @"";
    for (VENTouchLockPasscodeCharacterView *characterView in self.passcodeView.characters) {
        characterView.isEmpty = YES;
    }
}


#pragma mark - UITextField Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.shouldIgnoreTextFieldDelegateCalls) {
        return NO;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = [newString length];
    if (newLength > VENTouchLockViewControllerPasscodeLength) {
        [self.passcodeView shakeAndVibrateCompletion:nil];
        textField.text = @"";
        return NO;
    }
    else {
        for (VENTouchLockPasscodeCharacterView *characterView in self.passcodeView.characters) {
            NSUInteger index = [self.passcodeView.characters indexOfObject:characterView];
            characterView.isEmpty = (index >= newLength);
        }
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.shouldIgnoreTextFieldDelegateCalls) {
        return;
    }
    NSString *newString = textField.text;
    NSUInteger newLength = [newString length];

    if (newLength == VENTouchLockViewControllerPasscodeLength) {
        self.shouldIgnoreTextFieldDelegateCalls = YES;
        textField.text = @"";
        [self performSelector:@selector(enteredPasscode:) withObject:newString afterDelay:0.3];
    }
}

#pragma mark - Accessors

- (VENTouchLock *)touchLock {
    if (!_touchLock) {
        _touchLock = [VENTouchLock sharedInstance];
    }
    return _touchLock;
}
@end
