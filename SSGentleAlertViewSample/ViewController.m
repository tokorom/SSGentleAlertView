//
//  ViewController.m
//
//  Created by ytokoro on 5/25/13.
//

#import "ViewController.h"
#import "SSGentleAlertView.h"
#import "SSDialogView.h"

@interface ViewController ()
@property (assign) SSGentleAlertViewStyle style;
@property (weak) IBOutlet UISegmentedControl* segmentedControl;
@property (assign, getter=isOriginal) BOOL original;
@end 

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = NO;
  self.navigationController.toolbarHidden = NO;
}

- (IBAction)button1DidPush:(id)sender
{
  /*
  UIAlertView* alert;
  //alert = [[UIAlertView alloc] initWithTitle:nil
                                     //message:@"Hello, SSGentleAlertView!"
  alert = [[UIAlertView alloc] initWithTitle:@"Hello, SSGentleAlertView! 1234567890"
                                     message:@"Hello, SSGentleAlertView! 1234567890"
                                    delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"OK", nil];
                           */
  SSGentleAlertView* alert;
  alert = [[SSGentleAlertView alloc] initWithStyle:self.style
                                             title:@"Hello, SSGentleAlertView!"
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"OK", nil];
  if (self.isOriginal) {
    [self.class setAppearanceToGentleAlertView:alert];
    alert.disappearWhenBackgroundClicked = YES;
  }
  [alert show];
}

- (IBAction)button2DidPush:(id)sender
{
  //UIAlertView* alert = [UIAlertView new];
  SSGentleAlertView* alert = [[SSGentleAlertView alloc] initWithStyle:self.style];
  alert.delegate = self;
  alert.title = @"SSGentleAlertView";
  alert.message = @"This is GentleAlertView!\nUIAlertView is too strong to use for ordinary messages.";
  alert.cancelButtonIndex = 0;
  [alert addButtonWithTitle:@"Cancel"];
  [alert addButtonWithTitle:@"OK"];
  if (self.isOriginal) {
    [self.class setAppearanceToGentleAlertView:alert];
    alert.disappearWhenBackgroundClicked = YES;
  }
  [alert show];
}

- (IBAction)button3DidPush:(id)sender
{
  //UIAlertView* alert = [UIAlertView new];
  SSGentleAlertView* alert = [[SSGentleAlertView alloc] initWithStyle:self.style];
  alert.delegate = self;
  alert.title = @"SSGentleAlertView";
  alert.message = @"This is GentleAlertView!\nUIAlertView is too strong to use for ordinary messages.";
  [alert addButtonWithTitle:@"OK"];
  [alert addButtonWithTitle:@"Later"];
  [alert addButtonWithTitle:@"Cancel"];
  alert.cancelButtonIndex = alert.numberOfButtons - 1;
  if (self.isOriginal) {
    [self.class setAppearanceToGentleAlertView:alert];
    alert.disappearWhenBackgroundClicked = YES;
  }
  [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSLog(@"alertView:clickedButtonAtIndex:%d", buttonIndex);
}

- (IBAction)styleDidChange:(UISegmentedControl*)segmentedControl
{
  self.original = NO;
  switch (segmentedControl.selectedSegmentIndex) {
    case 1:
      [self updateStyle:SSGentleAlertViewStyleBlack];
      break;
    case 2:
      [self updateStyle:SSGentleAlertViewStyleNative];
      break;
    case 3:
      self.original = YES;
      [self updateStyle:SSGentleAlertViewStyleDefault];
      break;
    default:
      [self updateStyle:SSGentleAlertViewStyleDefault];
      break;
  }
}

- (void)updateStyle:(SSGentleAlertViewStyle)style
{
  switch (style) {
    case SSGentleAlertViewStyleNative:
      self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
      self.navigationController.toolbar.barStyle = UIBarStyleDefault;
      self.segmentedControl.tintColor = nil;
      break;
    case SSGentleAlertViewStyleBlack:
      self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
      self.navigationController.toolbar.barStyle = UIBarStyleBlack;
      self.segmentedControl.tintColor = UIColor.blackColor;
      break;
    default:
      self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
      self.navigationController.toolbar.barStyle = UIBarStyleDefault;
      self.segmentedControl.tintColor = nil;
      break;
  }
  self.style = style;
}

+ (void)setAppearanceToGentleAlertView:(SSGentleAlertView*)alertView
{
  alertView.backgroundImageView.image = [UIImage imageNamed:@"dialog_bg"];
  alertView.dialogImageView.image = nil;

  alertView.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
  alertView.titleLabel.shadowColor = UIColor.clearColor;
  alertView.messageLabel.textColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.0 alpha:1.0];
  alertView.messageLabel.shadowColor = UIColor.clearColor;

  UIButton* button = [alertView buttonBase];
  [button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_normal"]] forState:UIControlStateNormal];
  [button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_pressed"]] forState:UIControlStateHighlighted];
  [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
  [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
  [alertView setButtonBase:button];
  [alertView setDefaultButtonBase:button];
}

@end
