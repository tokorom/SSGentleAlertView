//
//  ViewController.m
//
//  Created by ytokoro on 5/25/13.
//

#import "ViewController.h"
#import "SSGentleAlertView.h"

@interface ViewController ()
@property (nonatomic) SSGentleAlertViewStyle style;
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
  [alert show];
}

- (IBAction)button3DidPush:(id)sender
{
  //UIAlertView* alert = [UIAlertView new];
  SSGentleAlertView* alert = [[SSGentleAlertView alloc] initWithStyle:self.style];
  alert.delegate = self;
  alert.title = @"SSGentleAlertView";
  alert.message = @"This is GentleAlertView!\nUIAlertView is too strong to use for ordinary messages.";
  alert.cancelButtonIndex = 2;
  [alert addButtonWithTitle:@"OK"];
  [alert addButtonWithTitle:@"Later"];
  [alert addButtonWithTitle:@"Cancel"];
  [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSLog(@"alertView:clickedButtonAtIndex:%d", buttonIndex);
}

- (IBAction)styleDidChange:(UISegmentedControl*)segmentedControl
{
  switch (segmentedControl.selectedSegmentIndex) {
    case 1:
      [self updateStyle:SSGentleAlertViewStyleNative];
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
      break;
    default:
      self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
      self.navigationController.toolbar.barStyle = UIBarStyleDefault;
      break;
  }
  self.style = style;
}

@end
