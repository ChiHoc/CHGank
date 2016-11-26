//
//  GKListDataSource.h
//  Quketi
//
//  Created by ChiHo on 3/29/16.
//  Copyright © 2016 YouthMBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKListDataSource;

@protocol GKListDataSourceDelegate <NSObject>

/**
 *  响应收到网络返回
 *
 *  @param dataSource 消息
 */
- (void)dataSourceDidReceiveResponse:(GKListDataSource *)dataSource;

/**
 *  响应收到失败返回
 *
 *  @param dataSource 消息
 */
- (void)dataSourceDidFailedToRequestData:(GKListDataSource *)dataSource;

/**
 *  响应刷新数据
 *
 *  @param dataSource 消息
 */
- (void)dataSourceDidRefreshData:(GKListDataSource *)dataSource;

/**
 *  响应新增数据
 *
 *  @param dataSource 消息
 */
- (void)dataSource:(GKListDataSource *)dataSource didAddDataWithStart:(NSInteger)start length:(NSInteger)length;

/**
 *  响应收到所有数据
 *
 *  @param dataSource 消息
 */
- (void)dataSourceDidLoadAllData:(GKListDataSource *)dataSource;

@end

@interface GKListDataSource : NSObject

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL isLoadAll;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) double total;
@property (nonatomic, weak) id<GKListDataSourceDelegate> delegate;
@property (nonatomic, assign) CHRequestType requestType;

/**
 *  获取公开课课程列表
 *
 *  @param isRefresh 是否刷新
 */
- (void)requestData:(BOOL)isRefresh;

@end
