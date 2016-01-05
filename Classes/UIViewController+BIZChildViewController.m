//
//  UIViewController+BIZChildViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 11/5/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "UIViewController+BIZChildViewController.h"


@implementation UIViewController (BIZChildViewController)


- (void)containerAddChildViewController:(UIViewController *)childViewController
{
    [self addChildViewController:childViewController];
    [self.view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

- (void)containerAddChildViewController:(UIViewController *)childViewController withRootView:(UIView *)rootView
{
    [self addChildViewController:childViewController];
    [rootView addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
}

- (void)containerRemoveChildViewController:(UIViewController *)childViewController
{
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}

@end