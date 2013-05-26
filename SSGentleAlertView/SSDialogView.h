//
//  SSDialogView.h
//
//  Created by ToKoRo on 2013-05-19.
//

#import "SSGentleAlertViewStyle.h"

@interface SSDialogView : UIView
@property (weak) id<UIAlertViewDelegate> delegate;
- (void)setupWithButtonCaptions:(NSArray*)buttonCaptions;
- (void)setViewStyle:(SSGentleAlertViewStyle)style;
@end
