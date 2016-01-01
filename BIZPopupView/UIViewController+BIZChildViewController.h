//
//  UIViewController+BIZChildViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 11/5/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (BIZChildViewController)
- (void)containerAddChildViewController:(UIViewController *)childViewController;
- (void)containerAddChildViewController:(UIViewController *)childViewController withRootView:(UIView *)rootView;
- (void)containerRemoveChildViewController:(UIViewController *)childViewController;
@end