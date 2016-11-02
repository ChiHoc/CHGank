//
//  GKWebViewController.h
//  Quketi
//
//  Created by ChiHo on 14/10/29.
//  Copyright (c) 2014年 YouthMBA. All rights reserved.
//

#import "GKViewController.h"

@interface GKWebViewController : GKViewController

@property (nonatomic, strong) NSString *userAgent;

- (id)initWithRequestString:(NSString *)string;

- (id)initWithRequestURL:(NSURL *)URL;

@end
