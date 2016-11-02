//
//  GKTableListController.h
//  Quketi
//
//  Created by youthmba3 on 16/5/25.
//  Copyright © 2016年 YouthMBA. All rights reserved.
//

#import "GKTableViewController.h"
#import "GKListDataSource.h"

static NSString *const tableListCellIdentifier = @"listCell";

@interface GKTableListController : GKTableViewController <GKListDataSourceDelegate>

/**
 *  列表cell类
 *
 *  @return 列表cell类
 */
- (Class)listCellClass;

/**
 *  列表对应节
 *
 *  @return 列表对应节
 */
- (NSInteger)listSection;

/**
 *  列表数据源
 *
 *  @return 数据源
 */
- (GKListDataSource *)dataSource;

/**
 *  列表空文字
 *
 *  @return 列表空文字
 */
- (NSString *)emptyLabelText;

/**
 *  是否需要header
 *
 *  @return 是否需要
 */
- (BOOL)isHeaderAvailable;

/**
 *  是否需要footer
 *
 *  @return 是否需要
 */
- (BOOL)isFooterAvailable;

/**
 *  重置Header和Footer
 */
- (void)resetHeaderFooter;

/**
 *  列表cell
 *
 *  @param tableView 列表
 *  @param indexPath 位置
 *
 *  @return 列表cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView listCellAtIndex:(NSInteger)index;

/**
 *  列表cell高度
 *
 *  @param tableView 列表
 *  @param indexPath 位置
 *
 *  @return 列表cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndex:(NSInteger)index;

/**
 *  点击列表cell
 *
 *  @param tableView 列表
 *  @param indexPath 位置
 *
 *  @return 点击列表cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)index;

/**
 *  列表Cell高亮
 *
 *  @param tableView 列表
 *  @param index     位置
 *
 *  @return 列表Cell高亮
 */
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndex:(NSInteger)index;

@end
