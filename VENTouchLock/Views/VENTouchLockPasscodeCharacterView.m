#import "VENTouchLockPasscodeCharacterView.h"

@interface VENTouchLockPasscodeCharacterView ()

@property (strong, nonatomic) CAShapeLayer *circle;
@property (strong, nonatomic) CAShapeLayer *hyphen;

@end

@implementation VENTouchLockPasscodeCharacterView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _isEmpty = YES;
    self.backgroundColor = [UIColor clearColor];
    [self drawCircle];
    [self drawHyphen];
    [self redraw];
}

- (void)redraw
{
    self.circle.hidden = self.isEmpty;
    self.hyphen.hidden = !self.isEmpty;
}

- (void)drawCircle
{
    CGFloat borderWidth = 2;
    CGFloat radius = (CGRectGetWidth(self.bounds) - borderWidth) / 2;
    CGFloat offset = (CGRectGetWidth(self.bounds) - (radius * 2) - borderWidth)/2.0f;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(offset, offset, 2.0*radius, 2.0*radius)

                                             cornerRadius:radius].CGPath;
    UIColor *circleColor = self.circleFillColor ?: [UIColor blackColor];
    circle.fillColor = circleColor.CGColor;
    circle.strokeColor =  circleColor.CGColor;
    circle.borderWidth = borderWidth;
    [self.layer addSublayer:circle];
    _circle = circle;
}

- (void)drawHyphen
{
    CGFloat borderWidth = 2;
    CGFloat radius = ((CGRectGetWidth(self.bounds) - borderWidth) / 2)/2.0f;
    CGFloat offset = (CGRectGetWidth(self.bounds) - (radius * 2) - borderWidth)/2.0f;
    CAShapeLayer *hyphen = [CAShapeLayer layer];
    hyphen.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(offset, offset, 2.0*radius, 2.0*radius)
                   
                                             cornerRadius:radius].CGPath;
    UIColor *hyphenColor = self.hyphenFillColor ? : [UIColor blackColor];
    hyphen.fillColor = hyphenColor.CGColor;
    hyphen.strokeColor =  hyphenColor.CGColor;
    hyphen.borderWidth = borderWidth;
    
    [self.layer addSublayer:hyphen];
    _hyphen = hyphen;
}

- (void)setIsEmpty:(BOOL)isEmpty {
    if (_isEmpty != isEmpty) {
        _isEmpty = isEmpty;
        [self redraw];
    }
}
- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    _circleFillColor = fillColor;
    _hyphenFillColor = fillColor;
    CGColorRef cgColor = fillColor.CGColor;
    self.hyphen.fillColor = cgColor;
    self.hyphen.strokeColor = cgColor;
    self.circle.fillColor = cgColor;
    self.circle.strokeColor = cgColor;
}


- (void)setCircleFillColor:(UIColor *)fillColor
{
    _circleFillColor = fillColor;
    CGColorRef cgColor = fillColor.CGColor;
    self.circle.fillColor = cgColor;
    self.circle.strokeColor = cgColor;
}

- (void)setHyphenFillColor:(UIColor *)fillColor
{
    _hyphenFillColor = fillColor;
    CGColorRef cgColor = fillColor.CGColor;
    self.hyphen.fillColor = cgColor;
    self.hyphen.strokeColor = cgColor;
}


@end
