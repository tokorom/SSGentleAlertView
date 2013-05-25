//
//  SSDialogView.h
//
//  Created by ToKoRo on 2013-05-19.
//

@interface SSDialogView : UIView
@property (weak) id<UIAlertViewDelegate> delegate;
- (void)setupWithButtonCaptions:(NSArray*)buttonCaptions;
- (void)updateOrientation;
@end
