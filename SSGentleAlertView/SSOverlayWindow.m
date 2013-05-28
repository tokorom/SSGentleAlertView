//
//  SSOverlayWindow.m
//
//  Created by ToKoRo on 2013-05-28.
//

#import "SSOverlayWindow.h"

@interface SSOverlayWindow ()
@property (weak) UIWindow* previousKeyWindow;
@end 

@implementation SSOverlayWindow

- (id)init
{
  if ((self = [super init])) {
    self.frame = [[UIScreen mainScreen] bounds];
  }
  return self;
}

- (void)makeKeyAndVisible
{
  self.previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
  self.windowLevel = UIWindowLevelAlert;
  [super makeKeyAndVisible];
}

- (void)resignKeyWindow
{
  [super resignKeyWindow];
  [self.previousKeyWindow makeKeyAndVisible];
}

@end
