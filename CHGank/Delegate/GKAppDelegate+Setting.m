//
//  GKAppDelegate+Setting.m
//  Quketi
//
//  Created by ChiHo on 10/13/15.
//  Copyright (c) 2015 YouthMBA. All rights reserved.
//

#import "GKAppDelegate+Setting.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate (Setting)

- (void)settingApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [self setupConrtolAppearence];
}

/**
 *  设置全局外观
 */
- (void)setupConrtolAppearence
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    if (iOS8AndLater) {
        [[UINavigationBar appearance] setTranslucent:NO];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"NaviBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]
                                           forBarMetrics:UIBarMetricsDefault];
    }
    [[UINavigationBar appearance] setBarTintColor:color_fffdf8];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:color_7a8b9f,
                                                           NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    [[UINavigationBar appearance] setTintColor:color_7a8b9f];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"separator"]];
    
    if (iOS8AndLater) {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : color_b5bbc4,
                                                            NSFontAttributeName : [UIFont systemFontOfSize:10 weight:UIFontWeightMedium]}
                                                 forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_7a8b9f,
                                                            NSFontAttributeName : [UIFont systemFontOfSize:10 weight:UIFontWeightMedium]}
                                                 forState:UIControlStateSelected];
    } else {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : color_b5bbc4,
                                                            NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                                 forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: color_7a8b9f,
                                                            NSFontAttributeName : [UIFont systemFontOfSize:10]}
                                                 forState:UIControlStateSelected];
    }
    [[UITabBar appearance] setTintColor:color_b5bbc4];
    [[UITabBar appearance] setBarTintColor:color_fffdf8];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"separator"]];
    
    [[UIToolbar appearance] setTintColor:color_fffdf8];
    [[UISearchBar appearance] setTintColor:color_7a8b9f];
    [[UITextField appearance] setTintColor:color_7a8b9f];
    [[UITextView appearance] setTintColor:color_7a8b9f];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:color_fffdf8];
    [[UIPageControl appearance] setPageIndicatorTintColor:RGBA(0xff, 0xfd, 0xf8, 0.4)];
}

@end
