#import "VENTouchLockPasscodeView.h"
#import "VENTouchLockPasscodeCharacterView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface VENTouchLockPasscodeView ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *firstCharacter;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *secondCharacter;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *thirdCharacter;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *fourthCharacter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapBetweenNumberAndTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberVerticalCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapBetweenLogoAndTitle;

@end

@implementation VENTouchLockPasscodeView

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)font characterColor:(UIColor *)characterColor
{
    NSArray *nibArray = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self options:nil];
    self = [nibArray firstObject];
    if (self) {
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        _title = title;
        _titleLabel.text = title;
        _titleColor = titleColor;
        _titleLabel.textColor = titleColor;
        _titleFont = _titleLabel.font;
        
        if (font) {
            _titleLabel.font = font;
            _titleFont = font;
        }
        
        _characterColor = characterColor;
        _characters = @[_firstCharacter, _secondCharacter, _thirdCharacter, _fourthCharacter];
        
        _verticalGapTitleAndCharacter = _gapBetweenNumberAndTitle.constant;
        
        for (VENTouchLockPasscodeCharacterView *characterView in _characters) {
            characterView.fillColor = characterColor;
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)font characterColor:(UIColor *)characterColor emptyCharacterColor:(UIColor *)emptyCharacterColor
{
    if (self = [self initWithTitle:title frame:frame titleColor:titleColor titleFont:font characterColor:characterColor]) {
        for (VENTouchLockPasscodeCharacterView *characterView in _characters) {
            characterView.hyphenFillColor = emptyCharacterColor;
        }
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;
{
    return [self initWithTitle:title frame:frame titleColor:[UIColor blackColor] titleFont:nil characterColor:[UIColor blackColor]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitle:@"" frame:frame];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)shakeAndVibrateCompletion:(void (^)(void))completionBlock
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
    NSString *keyPath = @"position";
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:keyPath];
    [animation setDuration:0.04];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    CGFloat delta = 10.0;
    CGPoint center = self.center;
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(center.x - delta, center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(center.x + delta, center.y)]];
    [[self layer] addAnimation:animation forKey:keyPath];
    [CATransaction commit];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setCharacterColor:(UIColor *)characterColor
{
    _characterColor = characterColor;
    for (VENTouchLockPasscodeCharacterView *characterView in self.characters) {
        characterView.fillColor = characterColor;
    }
}

- (void)setEmptyCharacterColor:(UIColor *)emptyCharacterColor
{
    _emptyCharacterColor = emptyCharacterColor;
    for (VENTouchLockPasscodeCharacterView *characterView in self.characters) {
        characterView.hyphenFillColor = emptyCharacterColor;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setVerticalGapTitleAndCharacter:(CGFloat)verticalGapTitleAndCharacter {
    _verticalGapTitleAndCharacter = verticalGapTitleAndCharacter;
    self.gapBetweenNumberAndTitle.constant = _verticalGapTitleAndCharacter;
    [self setNeedsUpdateConstraints];
}

- (void)setLogoImage:(UIImage *)logo {
    self.logoImageView.image = logo;
    if (logo) {
        self.numberVerticalCenter.constant = self.gapBetweenLogoAndTitle.constant;
        self.logoWidth.constant = logo.size.width;
        self.logoHeight.constant = logo.size.height;
    } else {
        self.numberVerticalCenter.constant = 0.0f;
    }
    [self setNeedsUpdateConstraints];
}
@end
