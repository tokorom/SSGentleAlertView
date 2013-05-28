//
//  SSGentleAlertView.m
//
//  Created by ToKoRo on 2013-05-19.
//

#import "SSGentleAlertView.h"
#import "SSDialogView.h"
#import "SSOverlayWindow.h"

@interface SSGentleAlertView ()
@property (weak) IBOutlet UIView* backgroundView;
@property (weak) IBOutlet UIImageView* backgroundImageView;
@property (weak) IBOutlet SSDialogView* dialogView;
@property (weak) IBOutlet UILabel* titleLabel;
@property (weak) IBOutlet UILabel* messageLabel;
@property (strong) NSMutableArray* buttonCaptions;
@property (assign) CGAffineTransform backupDialogTransform;
@property (nonatomic) SSGentleAlertViewStyle style;
@property (strong) UIWindow* overlayWindow;
@end 

@implementation SSGentleAlertView

#pragma mark - Lifecycle

- (id)init
{
  if ((self = [self initWithStyle:SSGentleAlertViewStyleDefault])) {
  }
  return self;
}

- (id)initWithStyle:(SSGentleAlertViewStyle)style
{
  self = (id)[self.class gentleAlertViewFromNibForStyle:style];
  if (self) {
    self.style = style;
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.buttonCaptions = [NSMutableArray array];
    self.titleLabel.hidden = YES;
    self.messageLabel.hidden = YES;
    self.hidden = YES;
  }
  return self;
}

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...
{
  va_list args;
  va_start(args, otherButtonTitles);
  if ((self = [self initWithStyle:SSGentleAlertViewStyleDefault title:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitles args:args])) {
  }
  va_end(args);
  return self;
}

- (id)initWithStyle:(SSGentleAlertViewStyle)style title:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...
{
  va_list args;
  va_start(args, otherButtonTitles);
  if ((self = [self initWithStyle:style title:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitles args:args])) {
  }
  va_end(args);
  return self;
}

- (id)initWithStyle:(SSGentleAlertViewStyle)style title:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle args:(va_list)args
{
  if ((self = [self initWithStyle:style])) {
    self.title = title;
    self.message = message;
    self.delegate = delegate;
    if (nil != cancelButtonTitle) {
      self.cancelButtonIndex = 0;
      [self addButtonWithTitle:cancelButtonTitle];
    }

    NSString* title = otherButtonTitle;
    while (title) {
      [self addButtonWithTitle:title];
      title = va_arg(args, typeof(NSString*));
    }
  }
  return self;
}

+ (UIView*)gentleAlertViewFromNibForStyle:(SSGentleAlertViewStyle)style
{
  UINib* nib = [UINib nibWithNibName:[self.class nibNameForStyle:style] bundle:nil];
  NSArray* instances = [nib instantiateWithOwner:self options:nil];
  if (0 < instances.count) {
    return instances[0];
  }
  return nil;
}

#pragma mark - Accessors

- (NSString*)title
{
  return self.titleLabel.text;
}

- (void)setTitle:(NSString*)title
{
  self.titleLabel.hidden = !title;
  self.titleLabel.text = title;
}

- (NSString*)message
{
  return self.messageLabel.text;
}

- (void)setMessage:(NSString*)message
{
  self.messageLabel.hidden = !message;
  self.messageLabel.text = message;
}

- (BOOL)isVisible
{
  return !self.hidden;
}

- (NSInteger)numberOfButtons
{
  return self.buttonCaptions.count;
}

#pragma mark - Public Interface

- (void)show
{
  self.hidden = NO;

  [self setup];

  UIWindow* window = SSOverlayWindow.new;
  self.frame = window.bounds;

  [window addSubview:self];
  [window makeKeyAndVisible];
  self.overlayWindow = window;

  [self startStateForPopupAnimation];
  __weak id SELF = self;
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{ [SELF finishStateForPopupAnimation]; }
                   completion:nil];
}

- (NSInteger)addButtonWithTitle:(NSString*)title
{
  [self.buttonCaptions addObject:title];
  return self.buttonCaptions.count - 1;
}

- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex
{
  return self.buttonCaptions[buttonIndex];
}

#pragma mark - Appearance

- (UIImageView*)dialogImageView
{
  return self.dialogView.dialogImageView;
}

- (UIButton*)buttonBase
{
  return [self.dialogView buttonBase];
}

- (void)setButtonBase:(UIButton*)buttonBase
{
  [self.dialogView setButtonBase:buttonBase];
}

- (UIButton*)defaultButtonBase
{
  return [self.dialogView defaultButtonBase];
}

- (void)setDefaultButtonBase:(UIButton*)buttonBase
{
  [self.dialogView setDefaultButtonBase:buttonBase];
}

#pragma mark - Private Methods

- (void)setup
{
  // Dialog

  [self.dialogView setViewStyle:self.style];
  [self.dialogView setupWithButtonCaptions:self.buttonCaptions];

  // Background

  if (self.disappearWhenBackgroundClicked) {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidTap)];
    [self addGestureRecognizer:tapGesture];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidTap)];
    [self.backgroundView addGestureRecognizer:tapGesture];
  }

  [self.dialogView sizeToFit];
  self.dialogView.center = self.center;
}

- (void)buttonDidPush:(UIButton*)button
{
  NSInteger buttonIndex = button.tag;
  [self removeByButtonIndex:buttonIndex];
}

- (void)removeByButtonIndex:(NSInteger)buttonIndex
{
  if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
    [self.delegate alertView:(UIAlertView*)self clickedButtonAtIndex:buttonIndex];
  }

  if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
    [self.delegate alertView:(UIAlertView*)self willDismissWithButtonIndex:buttonIndex];
  }
  [self remove];
  if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
    [self.delegate alertView:(UIAlertView*)self didDismissWithButtonIndex:buttonIndex];
  }
}

- (void)backgroundDidTap
{
  [self removeByButtonIndex:self.cancelButtonIndex];
}

- (void)cancel
{
  [self remove];
}

- (void)remove
{
  [self startStateForDisappearAnimation];
  __weak id SELF = self;
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{ [SELF finishStateForDisappearAnimation]; }
                   completion:^(BOOL finished){ [SELF removeSelfAndWindow]; }];
}

- (void)removeSelfAndWindow
{
  [self.window resignKeyWindow];
  self.overlayWindow = nil;
}

- (void)startStateForPopupAnimation
{
  self.alpha = 0.0;
  self.backupDialogTransform = self.dialogView.transform;
  self.dialogView.transform = CGAffineTransformScale(self.dialogView.transform, 0.25, 0.25);
}

- (void)finishStateForPopupAnimation
{
  self.alpha = 1.0;
  self.dialogView.transform = self.backupDialogTransform;
}

- (void)startStateForDisappearAnimation
{
  self.alpha = 1.0;
}

- (void)finishStateForDisappearAnimation
{
  self.alpha = 0.0;
  self.dialogView.transform = CGAffineTransformScale(self.dialogView.transform, 0.25, 0.25);
}

+ (NSString*)nibNameForStyle:(SSGentleAlertViewStyle)style
{
  switch (style) {
    case SSGentleAlertViewStyleNative: return @"SSGentleAlertViewNative";
    case SSGentleAlertViewStyleBlack: return @"SSGentleAlertViewBlack";
    default: return @"SSGentleAlertViewDefault";
  }
}

@end
