//
//  GKTableViewController.h
//  Quketi
//
//  Created by ChiHo on 8/11/15.
//  Copyright (c) 2015 YouthMBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface GKTableViewController : UITableViewController

/**
 *  释放内存
 */
- (void)releaseMemory;

/**
 *  设置导航条 标题
 *
 *  @param title 标题文本
 */
- (void)setNavigationBarTitle:(NSString *)title;

/**
 *  配置下拉刷新
 *
 *  @param headerRefreshingBlock 下拉刷新方法
 */
- (void)setHeaderWithRefreshingBlock:(void(^)())headerRefreshingBlock;

/**
 *  配置上拉加载
 *
 *  @param footerRefreshingBlock 上拉加载方法
 */
- (void)setFooterWithRefreshingBlock:(void(^)())footerRefreshingBlock;

@end
