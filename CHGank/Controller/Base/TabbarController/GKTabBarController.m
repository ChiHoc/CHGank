//
//  GKTabBarController.m
//  Quketi
//
//  Created by ChiHo on 14-7-3.
//  Copyright (c) 2014年 YouthMBA. All rights reserved.
//

#import "GKTabBarController.h"
#import "GKNotifyProtocol.h"
#import "SDImageCache.h"

@interface GKTabBarController () <UITabBarControllerDelegate>

@end

@implementation GKTabBarController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - 方法

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.selectedViewController) {
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.selectedViewController) {
        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
    }
    
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
}

@end
