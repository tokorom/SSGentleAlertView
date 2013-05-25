//
//  SSGentleAlertView.h
//
//  Created by ToKoRo on 2013-05-19.
//

@interface SSGentleAlertView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

@property (nonatomic) NSInteger cancelButtonIndex;

@property (nonatomic) BOOL disappearWhenBackgroundClicked;

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ...;

- (void)show;
- (NSInteger)addButtonWithTitle:(NSString*)title;

@end
