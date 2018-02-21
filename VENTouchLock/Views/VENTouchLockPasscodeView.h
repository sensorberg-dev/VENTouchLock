#import <UIKit/UIKit.h>

@interface VENTouchLockPasscodeView : UIView

/**
 The title string directly on top of the passcode characters.
 */
@property (strong, nonatomic) NSString *title;

/**
 An array of the passcode character subviews.
 */
@property (strong, nonatomic) NSArray *characters;

/**
 The color of the title text.
 */
@property (strong, nonatomic) UIColor *titleColor;

/**
 The font of the title text.
 */
@property (strong, nonatomic) UIFont *titleFont;

/**
 The color of the passcode characters.
 */
@property (strong, nonatomic) UIColor *characterColor;

/**
 The color of the passcode characters.
 */
@property (strong, nonatomic) UIColor *emptyCharacterColor;

/**
 The gap between title label and dotted characters
 */
@property (assign, nonatomic) CGFloat verticalGapTitleAndCharacter;

/**
 Creates a passcode view controller with the given title and frame.
 */
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;

/**
 Creates a passcode view controller with the given title and frame.
 */
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)font characterColor:(UIColor *)characterColor;

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)font characterColor:(UIColor *)characterColor emptyCharacterColor:(UIColor *)emptyCharacterColor;

/**
 Shakes the reciever and vibrates the device.
 @param completionBlock called after shake and vibrate complete
 */
- (void)shakeAndVibrateCompletion:(void (^)(void))completionBlock;

- (void)setLogoImage:(UIImage *)logo;

@end
