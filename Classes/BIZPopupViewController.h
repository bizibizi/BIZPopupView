//
//  BIZPopupViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 10/12/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIZPopupViewControllerDelegate.h"


@interface BIZPopupViewController : UIViewController

//! Designated initializer
- (instancetype)initWithContentViewController:(UIViewController *)contentViewController contentSize:(CGSize)contentSize;
@property (nonatomic, weak) id <BIZPopupViewControllerDelegate> delegate;
- (void)dismissPopupViewControllerAnimated:(BOOL)animated;
- (void)dismissPopupViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
//! Show Dismiss Button. YES is default
@property (nonatomic) BOOL showDismissButton;
//! Enable Background Fade and Popup is presented. YES is default
@property (nonatomic) BOOL enableBackgroundFade;

//* Subclass for customization
+ (UIColor *)kColor_modalBackground;
+ (UIColor *)kColor_modalBackgroundClear;
+ (UIImage *)kImage_dismissButton;
+ (CGSize)kSize_dismissButton;
+ (CGFloat)kSideInset_dismissButton;
+ (CGFloat)kCornerRadius;

@end
