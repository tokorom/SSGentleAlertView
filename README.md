<small aligin='right'>[Japanese](README.ja.md)</small>
-----
# SSGentleAlertView

* It is gnetler than UIAlertView
* It can be used in the same way as UIAlertView
* It can be changed the Appearance unlike UIAlertView

Designed by [Atsushi Morino](https://twitter.com/limonomori)

## Look and feel

### Default

{% img center http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewDefault.png %}

### Black

{% img center http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewBlack.png %}

### Native

{% img center http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewNative.png %}

## Supported UIAlertView's properties and methods

``` objc
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic, readonly) NSInteger numberOfButtons;

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...;
- (void)show;
- (NSInteger)addButtonWithTitle:(NSString*)title;
- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex;
```

## Additional functions

``` objc
/*
 * If set YES to this property, the dialog can be closed in the tap to the background part
 */
@property (nonatomic) BOOL disappearWhenBackgroundClicked;

/*
 * It is possible to select 3 styles (SSGentleAlertViewStyleDefault or SSGentleAlertViewStyleBlack or SSGentleAlertViewStyleNative)
 * when you use the init method
 */
- (id)initWithStyle:(SSGentleAlertViewStyle)style;
- (id)initWithStyle:(SSGentleAlertViewStyle)style title:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...;
```

## Samle code

``` objc
// #import "SSGentleAlertView.h"

// SSGentleAlertView can be used same way as UIAlertView

SSGentleAlertView* alert = SSGentleAlertView.new;
alert.delegate = self;
alert.title = @"SSGentleAlertView";
alert.message = @"This is GentleAlertView!\nUIAlertView is too strong to use for ordinary messages.";
[alert addButtonWithTitle:@"Cancel"];
[alert addButtonWithTitle:@"OK"];
alert.cancelButtonIndex = 0;
[alert show];
```

### Sample for customizing Appearance

{% img center http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewCustomize.png %}

``` objc
// #import "SSGentleAlertView.h"
// #import "SSDialogView.h"

alert.backgroundImageView.image = [UIImage imageNamed:@"dialog_bg"];
alert.dialogImageView.image = nil;

alert.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
alert.titleLabel.shadowColor = UIColor.clearColor;
alert.messageLabel.textColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.0 alpha:1.0];
alert.messageLabel.shadowColor = UIColor.clearColor;

UIButton* button = [alert buttonBase];
[button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_normal"]] forState:UIControlStateNormal];
[button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_pressed"]] forState:UIControlStateHighlighted];
[button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
[button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
[alert setButtonBase:button];
[alert setDefaultButtonBase:button];
```
