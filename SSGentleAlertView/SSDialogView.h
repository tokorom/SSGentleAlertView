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

+ (UIImage*)resizableImage:(UIImage*)image;

@end

@interface SSDialogView (Appearance)
- (UIImageView*)dialogImageView;
- (UIButton*)buttonBase;
- (UIButton*)defaultButtonBase;
- (void)setButtonBase:(UIButton*)buttonBase;
- (void)setDefaultButtonBase:(UIButton*)buttonBase;
@end
