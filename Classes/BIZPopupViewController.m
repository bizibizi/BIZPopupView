//
//  BIZPopupViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 10/12/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "BIZPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+BIZChildViewController.h"
#import "TPKeyboardAvoidingScrollView.h"


#define kDuration_animation 0.2


@interface BIZPopupViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;

//! Size of content
@property (nonatomic) CGSize contentSize;
//! ContentViewController
@property (nonatomic, strong) UIViewController *contentViewController;

@property (nonatomic) BOOL lightStatusBar;
@property (nonatomic, strong) UIButton *dismissButton;
@end


@implementation BIZPopupViewController


#pragma mark - Class


+ (UIColor *)kColor_modalBackground
{
    return [UIColor colorWithRed:29/255.0 green:39/255.0 blue:57/255.0 alpha:0.7];
}

+ (UIColor *)kColor_modalBackgroundClear
{
    return [[self kColor_modalBackground] colorWithAlphaComponent:0.0];
}

+ (UIImage *)kImage_dismissButton
{
    return [UIImage imageNamed:@"k-popup-dismiss-button"];
}

+ (CGSize)kSize_dismissButton
{
    return CGSizeMake(30.0, 30.0);
}

+ (CGFloat)kSideInset_dismissButton
{
    return 10.0;
}

+ (CGFloat)kCornerRadius
{
    return 4.0;
}


#pragma mark - LifeCycle


- (instancetype)initWithContentViewController:(UIViewController *)contentViewController contentSize:(CGSize)contentSize
{
    if (self = [super init]) {
        
        _contentViewController = contentViewController;
        _contentSize = contentSize;
        _showDismissButton = YES;
        _enableBackgroundFade = YES;
        
        if ([self respondsToSelector:@selector(loadViewIfNeeded)])
          [self loadViewIfNeeded];
        else {
          UIView *view = self.view;
        }
        
        [self createDismissButton];
        
        self.scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.contentSize = self.view.bounds.size;
        self.scrollView.alwaysBounceHorizontal = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.scrollView];
        self.scrollContentView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
        [self.scrollView addSubview:self.scrollContentView];
        self.view.backgroundColor = self.scrollContentView.backgroundColor = [UIColor clearColor];
        [self containerAddChildViewController:_contentViewController withRootView:self.scrollContentView];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self setupContentViewPosition];
        [self loadVisibleState:NO];

        //scrollView + view
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

        //scrollView + scrollContentView
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    }
    return self;
}

- (void)setupContentViewPosition
{
    self.contentViewController.view.bounds = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.contentViewController.view.center = self.view.center;
    
    [self.contentViewController.view layoutIfNeeded];
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setupContentViewPosition];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    self.contentViewController.view.layer.cornerRadius = [[self class] kCornerRadius];
    self.contentViewController.view.layer.masksToBounds = YES;

    [self createGestureEvents];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startPopupAppearance];
}

- (void)createDismissButton
{
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dismissButton setImage:[[self class] kImage_dismissButton] forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissPopupViewControllerAnimatedPassiveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];

    self.dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:[[self class] kSize_dismissButton].width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[[self class] kSize_dismissButton].height]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[[self class] kSideInset_dismissButton]]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-[[self class] kSideInset_dismissButton]]];
}

- (void)createGestureEvents
{
    UITapGestureRecognizer *gestureRecognizerPopupContentView = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    gestureRecognizerPopupContentView.numberOfTouchesRequired = 1;
    [self.contentViewController.view  addGestureRecognizer:gestureRecognizerPopupContentView];
    [gestureRecognizerPopupContentView setCancelsTouchesInView:NO];
    
    UITapGestureRecognizer *gestureRecognizerView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopupViewControllerAnimatedPassiveAction)];
    gestureRecognizerView.numberOfTouchesRequired = 1;
    [gestureRecognizerView requireGestureRecognizerToFail:gestureRecognizerPopupContentView];
    [self.view addGestureRecognizer:gestureRecognizerView];
    [gestureRecognizerPopupContentView setCancelsTouchesInView:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.lightStatusBar? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}


#pragma mark - Methods


- (void)setLightStatusBar:(BOOL)lightStatusBar
{
    _lightStatusBar = lightStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setShowDismissButton:(BOOL)showDismissButton
{
    _showDismissButton = showDismissButton;
    self.dismissButton.layer.hidden = !showDismissButton;
}


#pragma mark - Events


- (void)dismissPopupViewControllerAnimatedPassiveAction
{
    [self dismissPopupViewControllerAnimated:YES];
}

- (void)startPopupAppearance
{
    [UIView animateWithDuration:kDuration_animation
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [self loadVisibleState:YES];
                     } completion:nil];
}

- (void)dismissPopupViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewControllerWillDismiss)]) {
        [self.delegate popupViewControllerWillDismiss];
    }
    
    [UIView animateWithDuration:animated? kDuration_animation : 0.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [self loadVisibleState:NO];
                     } completion:^(BOOL finished) {
                         
                         [self containerRemoveChildViewController:self.contentViewController];
                         [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
                             
                             if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewControllerDidDismiss)]) {
                                 [self.delegate popupViewControllerDidDismiss];
                             }
                             
                             if (completion) {
                                 completion();
                             }
                         }];
                     }];
}

- (void)dismissPopupViewControllerAnimated:(BOOL)animated
{
    [self dismissPopupViewControllerAnimated:animated completion:nil];
}

- (void)loadVisibleState:(BOOL)visible
{
    if (visible) {
        for (UIView *i in [self subviews])
        {
            i.alpha = 1.0;
        }
        self.lightStatusBar = YES;
        if (self.enableBackgroundFade) {
            self.view.backgroundColor = [[self class] kColor_modalBackground];
        }
        self.contentViewController.view.transform = CGAffineTransformIdentity;
        
    } else {
        for (UIView *i in [self subviews])
        {
            i.alpha = 0.0;
        }
        self.lightStatusBar = NO;
        if (self.enableBackgroundFade) {
            self.view.backgroundColor = [[self class] kColor_modalBackgroundClear];
        }
        self.contentViewController.view.transform = CGAffineTransformMakeScale(0.001, 0.001);
    }
}

- (NSArray *)subviews
{
    return @[ self.dismissButton, self.contentViewController.view ];
}


#pragma mark - Rotation Delegate


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.view setNeedsLayout];
}

@end
