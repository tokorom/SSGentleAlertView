//
//  ViewController.m
//
//  Created by ytokoro on 5/25/13.
//

#import "ViewController.h"
#import "SSGentleAlertView.h"

@implementation ViewController

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
  //alert = [[SSGentleAlertView alloc] initWithTitle:nil
                                           //message:@"Hello, SSGentleAlertView!"
  alert = [[SSGentleAlertView alloc] initWithTitle:@"Hello, SSGentleAlertView!"
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"OK", nil];
  [alert show];
}

- (IBAction)button2DidPush:(id)sender
{
  //UIAlertView* alert = [UIAlertView new];
  SSGentleAlertView* alert = [SSGentleAlertView new];
  alert.delegate = self;
  alert.title = @"SSGentleAlertView";
  alert.message = @"This is a GentleAlertView!\nUIAlertView is too noisy to use for the normal messages.";
  alert.cancelButtonIndex = 0;
  [alert addButtonWithTitle:@"Cancel"];
  [alert addButtonWithTitle:@"OK"];
  [alert show];
}

- (IBAction)button3DidPush:(id)sender
{
  //UIAlertView* alert = [UIAlertView new];
  SSGentleAlertView* alert = [SSGentleAlertView new];
  alert.delegate = self;
  alert.title = @"SSGentleAlertView";
  alert.message = @"This is a GentleAlertView!\nUIAlertView is too noisy to use for the normal messages.";
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

@end
