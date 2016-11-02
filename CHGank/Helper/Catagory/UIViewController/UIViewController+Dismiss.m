//
//  UIViewController+Dismiss.m
//  Quketi
//
//  Created by ChiHo on 4/13/16.
//  Copyright © 2016 YouthMBA. All rights reserved.
//

#import "UIViewController+Dismiss.h"

@implementation UIViewController (Dismiss)

/**
 *  dimiss webView
 */
- (void)onCancelBtnDidPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
