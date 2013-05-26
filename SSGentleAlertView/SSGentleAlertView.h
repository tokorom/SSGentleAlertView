//
//  SSGentleAlertView.h
//
//  Created by ToKoRo on 2013-05-19.
//

#import "SSGentleAlertViewStyle.h"

@interface SSGentleAlertView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic, readonly) NSInteger numberOfButtons;

@property (nonatomic) BOOL disappearWhenBackgroundClicked;

- (id)initWithStyle:(SSGentleAlertViewStyle)style;
- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...;
- (id)initWithStyle:(SSGentleAlertViewStyle)style title:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...;

- (void)show;
- (NSInteger)addButtonWithTitle:(NSString*)title;
- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end

@interface SSGentleAlertView (Appearance)
- (UIImageView*)backgroundImageView;
- (UIImageView*)dialogImageView;
- (UILabel*)titleLabel;
- (UILabel*)messageLabel;
- (UIButton*)buttonBase;
- (UIButton*)defaultButtonBase;
- (void)setButtonBase:(UIButton*)buttonBase;
- (void)setDefaultButtonBase:(UIButton*)buttonBase;
@end
