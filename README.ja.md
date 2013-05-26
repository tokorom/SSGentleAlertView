# SSGentleAlertView

SSGentleAlertViewは、

* UIAlertViewよりもおとなしいダイアログ表示です
* UIAlertViewと同じ使い方ができます
* UIALertViewと違いAppearance（背景画像やフォントなど）を変更できます

Designed by [Atsushi Morino](https://twitter.com/limonomori)

## 表示イメージ

### Default

![SSGentleAlertViewDefault](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewDefault.png)

### Black

![SSGentleAlertViewBlack](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewBlack.png)

### Native

![SSGentleAlertViewNative](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewNative.png)

## サポートしているUIAlertViewのプロパティとメソッド

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

## 追加機能

``` objc
/*
 * これにYESを設定すると、背景部分をタップしたときもキャンセル扱いにしてダイアログを閉じる
 */
@property (nonatomic) BOOL disappearWhenBackgroundClicked;

/*
 * init時にSSGentleAlertViewStyleを設定することでダイアログのデザインを変更できる
 * SSGentleAlertViewStyleDefault / SSGentleAlertViewStyleBlack / SSGentleAlertViewStyleNative の3種を指定可能
 */
- (id)initWithStyle:(SSGentleAlertViewStyle)style;
- (id)initWithStyle:(SSGentleAlertViewStyle)style title:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...;
```

## 簡単なサンプルコード 

``` objc
// #import "SSGentleAlertView.h"

// UIAlertViewの使い方と全く同じ!

SSGentleAlertView* alert = SSGentleAlertView.new;
alert.delegate = self;
alert.title = @"SSGentleAlertView";
alert.message = @"This is GentleAlertView!\nUIAlertView is too strong to use for ordinary messages.";
[alert addButtonWithTitle:@"Cancel"];
[alert addButtonWithTitle:@"OK"];
alert.cancelButtonIndex = 0;
[alert show];
```

## Appearanceの変更例

![SSGentleAlertViewCustomize](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewCustomize.png)

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

-----

<small aligin='right'>[English](README.md) | Japanese</small>
