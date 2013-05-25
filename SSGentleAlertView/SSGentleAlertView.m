//
//  SSGentleAlertView.m
//
//  Created by ToKoRo on 2013-05-19.
//

#import "SSGentleAlertView.h"
#import "SSDialogView.h"

@interface SSGentleAlertView ()
@property (weak) IBOutlet UIView* backgroundView;
@property (weak) IBOutlet SSDialogView* dialogView;
@property (weak) IBOutlet UILabel* titleLabel;
@property (weak) IBOutlet UILabel* messageLabel;
@property (strong) NSMutableArray* buttonCaptions;
@property (assign) CGAffineTransform backupDialogTransform;
@end 

@implementation SSGentleAlertView

#pragma mark - Lifecycle

- (id)init
{
  self = (id)[self.class gentleAlertViewFromNib];
  if (self) {
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
  if ((self = [self init])) {
    self.delegate = delegate;
    self.title = title;
    self.message = message;
    if (nil != cancelButtonTitle) {
      self.cancelButtonIndex = 0;
      [self addButtonWithTitle:cancelButtonTitle];
    }

    va_list args;
    va_start(args, otherButtonTitles);
    NSString* title = otherButtonTitles;
    while (title) {
      [self addButtonWithTitle:title];
      title = va_arg(args, typeof(NSString*));
    }
    va_end(args);
  }
  return self;
}

+ (UIView*)gentleAlertViewFromNib
{
  UINib* nib = [UINib nibWithNibName:@"SSGentleAlertView" bundle:nil];
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

#pragma mark - Public Interface

- (void)show
{
  self.hidden = NO;

  [self setup];

  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  self.frame = window.bounds;

  for (UIView* subview in window.subviews) {
    if ([subview isKindOfClass:[self class]]) {
      [subview removeFromSuperview];
    } 
  }
  [window addSubview:self];

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

#pragma mark - Private Methods

- (void)setup
{
  // Dialog

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
                   completion:^(BOOL finished){ [SELF removeFromSuperview]; }];
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

@end
