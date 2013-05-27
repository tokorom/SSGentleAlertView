//
//  SSDialogView.m
//
//  Created by ToKoRo on 2013-05-19.
//

#import "SSDialogView.h"

@interface SSDialogView ()
@property (weak) IBOutlet UILabel* titleLabel;
@property (weak) IBOutlet UILabel* messageLabel;
@property (weak) IBOutlet UIImageView* dialogImageView;
@property (weak) IBOutlet UIView* buttonContainerView;
@property (assign) CGFloat defaultTitleLabelHeight;
@property (assign) CGFloat defaultMessageLabelHeight;
@property (assign) CGFloat defaultButtonContainerViewY;
@property (assign) CGFloat defaultButtonContainerViewHeight;
@property (strong) UIColor* buttonLabelShadowColor;
@property (assign) CGSize buttonLabelShadowOffset;
@property (nonatomic) SSGentleAlertViewStyle style;
@property (strong) UIButton* buttonBaseInstance;
@property (strong) UIButton* defaultButtonBaseInstance;
@end 

@implementation SSDialogView
  
#pragma mark - Lifecycle

- (void)awakeFromNib
{
  self.titleLabel.text = nil;
  self.messageLabel.text = nil;

  self.defaultTitleLabelHeight = self.titleLabel.bounds.size.height;
  self.defaultMessageLabelHeight = self.messageLabel.bounds.size.height;
  self.defaultButtonContainerViewY = self.buttonContainerView.frame.origin.y;
  self.defaultButtonContainerViewHeight = self.buttonContainerView.bounds.size.height;

  UIImage* dialogImage = self.dialogImageView.image;
  self.dialogImageView.image = [self.class resizableImage:dialogImage];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deviceDidRotate:)
                                               name:UIApplicationDidChangeStatusBarOrientationNotification
                                             object:nil];

  [self updateOrientation];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (UIButton*)buttonFromNibForStyle:(SSGentleAlertViewStyle)style
{
  UINib* nib = [UINib nibWithNibName:[self.class nibNameForStyle:style] bundle:nil];
  NSArray* instances = [nib instantiateWithOwner:self options:nil];
  if (0 < instances.count) {
    return instances[0];
  }
  return nil;
}

#pragma mark - Public Interface

- (void)setupWithButtonCaptions:(NSArray*)buttonCaptions
{
  CGFloat adjustY = 0.0;
  UILabel* label;
  CGSize labelSize;
  CGRect labelFrame;

  // Title
  
  if (0 < self.titleLabel.text.length) {
    label = self.titleLabel;
    CGSize labelSize = [label.text sizeWithFont:label.font
                              constrainedToSize:CGSizeMake(label.bounds.size.width, CGFLOAT_MAX)
                                  lineBreakMode:label.lineBreakMode];
    labelFrame = label.frame;
    labelFrame.size.height = labelSize.height;
    label.frame = CGRectIntegral(labelFrame);

    adjustY += labelFrame.size.height - self.defaultTitleLabelHeight;
  } else {
    adjustY -= self.messageLabel.frame.origin.y - self.titleLabel.frame.origin.y;
  }

  // Message

  if (0 < self.messageLabel.text.length) {
    label = self.messageLabel;
    labelSize = [label.text sizeWithFont:label.font
                       constrainedToSize:CGSizeMake(label.bounds.size.width, CGFLOAT_MAX)
                           lineBreakMode:label.lineBreakMode];
    labelFrame = label.frame;
    labelFrame.origin.y += adjustY;
    labelFrame.size.height = labelSize.height;
    label.frame = CGRectIntegral(labelFrame);

    adjustY += labelFrame.size.height - self.defaultMessageLabelHeight;
  } else {
    adjustY -= MIN(self.buttonContainerView.frame.origin.y - self.messageLabel.frame.origin.y, self.titleLabel.font.pointSize + 6.0);
  }

  // Buttons
  
  NSMutableArray* buttons = [NSMutableArray arrayWithCapacity:buttonCaptions.count];
  NSUInteger index = 0;
  for (NSString* buttonCaption in buttonCaptions) {
    UIButton* button = [self.class buttonFromNibForStyle:self.style];
    button.tag = index++;
    [button addTarget:self.superview
               action:@selector(buttonDidPush:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:buttonCaption forState:UIControlStateNormal];
    [self setupButton:button];
    if (nil != self.buttonBaseInstance) {
      [self.class setButtonAppearanceTo:button from:self.buttonBaseInstance];
    }
    [buttons addObject:button];
  }

  if (0 != adjustY) {
    CGRect frame = self.buttonContainerView.frame;
    frame.origin.y += adjustY;
    self.buttonContainerView.frame = frame;
  }

  UIButton* lastButton = nil;
  CGRect containerBounds = self.buttonContainerView.bounds;
  if (2 == buttons.count) {
    const CGFloat kButtonInterval = 5.0;
    const CGFloat kButtonWidth = containerBounds.size.width / 2 - kButtonInterval;
    UIButton* leftButton = buttons[0];
    UIButton* rightButton = buttons[1];
    CGRect buttonFrame = CGRectMake(0.0, 0.0, kButtonWidth, containerBounds.size.height);
    leftButton.frame = CGRectIntegral(buttonFrame);
    buttonFrame.origin.x = containerBounds.size.width - kButtonWidth;
    rightButton.frame = CGRectIntegral(buttonFrame);
    [self.buttonContainerView addSubview:leftButton];
    [self.buttonContainerView addSubview:rightButton];
    lastButton = leftButton;
  } else {
    const CGFloat kButtonInterval = 7.0;
    CGRect buttonFrame = containerBounds;
    for (int i = 0; i < buttons.count; ++i) {
      CGFloat buttonInterval = kButtonInterval;
      UIButton* button = buttons[i];
      button.frame = buttonFrame;
      [self.buttonContainerView addSubview:button];
      if (buttons.count - 2 == i) {
        buttonInterval *= 3;
      }
      buttonFrame.origin.y += buttonFrame.size.height + buttonInterval;
      if (0 < i) {
        CGRect buttonContainerViewFrame = self.buttonContainerView.frame;
        buttonContainerViewFrame.size.height += buttonFrame.size.height + buttonInterval;
        self.buttonContainerView.frame = CGRectIntegral(buttonContainerViewFrame);
      }
      if (1 < buttons.count) {
        lastButton = button;
      }
    }
  }
  if (nil != lastButton) {
    [self.class setDefaultButtonImageToButton:lastButton];
    if (nil != self.defaultButtonBaseInstance) {
      [self.class setButtonAppearanceTo:lastButton from:self.defaultButtonBaseInstance];
    }
  }
}

- (void)setViewStyle:(SSGentleAlertViewStyle)style
{
  self.style = style;
  NSString* bundlePath = [[NSBundle mainBundle] pathForResource:[self.class bundleNameForStyle:style] ofType:@"bundle"];
  NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
  NSString* plistPath = [bundle pathForResource:@"Layout" ofType:@"plist"];
  NSDictionary* layoutSetting = [NSDictionary dictionaryWithContentsOfFile:plistPath];

  self.buttonLabelShadowColor = [UIColor colorWithRed:[layoutSetting[@"ButtonShadowColorR"] floatValue]
                                                green:[layoutSetting[@"ButtonShadowColorG"] floatValue]
                                                 blue:[layoutSetting[@"ButtonShadowColorB"] floatValue]
                                                alpha:[layoutSetting[@"ButtonShadowColorA"] floatValue]];
  self.buttonLabelShadowOffset = CGSizeMake([layoutSetting[@"ButtonShadowOffsetX"] floatValue], [layoutSetting[@"ButtonShadowOffsetY"] floatValue]);
}

+ (UIImage*)resizableImage:(UIImage*)image
{
  const CGFloat capWidth = image.size.width  /  2;
  const CGFloat capHeight = image.size.height / 2;
  UIEdgeInsets capInsets = UIEdgeInsetsMake(capHeight, capWidth, capHeight, capWidth);
  return [image resizableImageWithCapInsets:capInsets];
}

#pragma mark - UIView Methods

- (CGSize)sizeThatFits:(CGSize)size
{

  CGFloat buttonContainerAdjustY = self.buttonContainerView.frame.origin.y - self.defaultButtonContainerViewY;
  CGFloat buttonContainerAdjustHeight = self.buttonContainerView.bounds.size.height - self.defaultButtonContainerViewHeight;
  size.height += buttonContainerAdjustY + buttonContainerAdjustHeight;

  return size;
}

#pragma mark - Appearance

- (UIButton*)buttonBase
{
  if (nil != self.buttonBaseInstance) {
    return self.buttonBaseInstance;
  } else {
    UIButton* button = [self.class buttonFromNibForStyle:self.style];
    return button;
  }
}

- (void)setButtonBase:(UIButton*)buttonBase
{
  self.buttonBaseInstance = buttonBase;
}

- (UIButton*)defaultButtonBase
{
  if (nil != self.defaultButtonBaseInstance) {
    return self.defaultButtonBaseInstance;
  } else {
    UIButton* button = [self.class buttonFromNibForStyle:self.style];
    [self.class setDefaultButtonImageToButton:button];
    return button;
  }
}

- (void)setDefaultButtonBase:(UIButton*)buttonBase
{
  self.defaultButtonBaseInstance = buttonBase;
}

#pragma mark - Private Methods

- (void)setupButton:(UIButton*)button
{
  [button setTitleShadowColor:self.buttonLabelShadowColor forState:UIControlStateNormal];
  button.titleLabel.shadowOffset = self.buttonLabelShadowOffset;
  [self.class setupBackgroundImagesForButton:button];
}

+ (void)setupBackgroundImagesForButton:(UIButton*)button
{
  [self setupBackgroundImagesForButton:button forState:UIControlStateNormal];
  [self setupBackgroundImagesForButton:button forState:UIControlStateHighlighted];
  [self setupBackgroundImagesForButton:button forState:UIControlStateSelected];
  [self setupBackgroundImagesForButton:button forState:UIControlStateDisabled];
}

+ (void)setupBackgroundImagesForButton:(UIButton*)button forState:(UIControlState)state
{
  UIImage* image = [button backgroundImageForState:state];
  [button setBackgroundImage:[self.class resizableImage:image] forState:state];
}

+ (void)setDefaultButtonImageToButton:(UIButton*)button
{
  UIImage* image = [button backgroundImageForState:UIControlStateDisabled];
  [button setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)deviceDidRotate:(NSNotification*)notification
{
  [self updateOrientation];
}

- (void)updateOrientation
{
    CGFloat rotateAngle = 0.0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
      case UIInterfaceOrientationPortraitUpsideDown:
        rotateAngle = M_PI;
        break;
      case UIInterfaceOrientationLandscapeLeft:
        rotateAngle = -M_PI / 2.0f;
        break;
      case UIInterfaceOrientationLandscapeRight:
        rotateAngle = M_PI / 2.0f;
        break;
      default:
        break;
    }
    if (0.0 != rotateAngle) {
      self.transform = CGAffineTransformMakeRotation(rotateAngle);
    } else {
      self.transform = CGAffineTransformIdentity;
    }
}

+ (NSString*)bundleNameForStyle:(SSGentleAlertViewStyle)style
{
  switch (style) {
    case SSGentleAlertViewStyleNative: return @"SSGentleAlertViewNative";
    case SSGentleAlertViewStyleBlack: return @"SSGentleAlertViewBlack";
    default: return @"SSGentleAlertViewDefault";
  }
}

+ (NSString*)nibNameForStyle:(SSGentleAlertViewStyle)style
{
  switch (style) {
    case SSGentleAlertViewStyleNative: return @"SSGentleAlertButtonNative";
    case SSGentleAlertViewStyleBlack: return @"SSGentleAlertButtonBlack";
    default: return @"SSGentleAlertButtonDefault";
  }
}

+ (void)setButtonAppearanceTo:(UIButton*)to from:(UIButton*)from
{
  [self.class setLabelAppearanceTo:to.titleLabel from:from.titleLabel];
  [self.class setButtonAppearanceTo:to from:from forState:UIControlStateNormal];
  [self.class setButtonAppearanceTo:to from:from forState:UIControlStateHighlighted];
  [self.class setButtonAppearanceTo:to from:from forState:UIControlStateSelected];
  [self.class setButtonAppearanceTo:to from:from forState:UIControlStateDisabled];
  to.reversesTitleShadowWhenHighlighted = from.reversesTitleShadowWhenHighlighted;
  to.adjustsImageWhenHighlighted = from.adjustsImageWhenHighlighted;
  to.adjustsImageWhenDisabled = from.adjustsImageWhenDisabled;
  to.showsTouchWhenHighlighted = from.showsTouchWhenHighlighted;
  to.tintColor = from.tintColor;
  to.contentEdgeInsets = from.contentEdgeInsets;
  to.titleEdgeInsets = from.titleEdgeInsets;
  to.imageEdgeInsets = from.imageEdgeInsets;
}

+ (void)setButtonAppearanceTo:(UIButton*)to from:(UIButton*)from forState:(UIControlState)state
{
  [to setTitleColor:[from titleColorForState:state] forState:state];
  [to setTitleShadowColor:[from titleShadowColorForState:state] forState:state];
  [to setBackgroundImage:[from backgroundImageForState:state] forState:state];
  [to setImage:[from imageForState:state] forState:state];
}

+ (void)setLabelAppearanceTo:(UILabel*)to from:(UILabel*)from
{
  to.font = from.font;
  to.textColor = from.textColor;
  to.highlightedTextColor = from.highlightedTextColor;
  to.shadowColor = from.shadowColor;
  to.shadowOffset = from.shadowOffset;
}

@end
