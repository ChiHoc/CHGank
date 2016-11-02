//
//  GKViewController.m
//  Quketi
//
//  Created by ChiHo on 6/30/15.
//  Copyright (c) 2015 YouthMBA. All rights reserved.
//

#import "GKViewController.h"
#import "GKNotifyProtocol.h"

@interface GKViewController ()<GKMainProtocol>

@end

@implementation GKViewController

#pragma mark - 初始化

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        REGISTER_EXTENSION(GKMainProtocol, self);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        REGISTER_EXTENSION(GKMainProtocol, self);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] init];
    backBtnItem.title = @"";
    self.navigationItem.backBarButtonItem = backBtnItem;
}

- (void)dealloc
{
    UNREGISTER_EXTENSION(GKMainProtocol, self);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[[UIDevice currentDevice] valueForKey:@"orientation"] intValue] != UIDeviceOrientationPortrait) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait)
                                    forKey:@"orientation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification
                                                            object:[UIDevice currentDevice]];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - 生命周期

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // 是否是正在使用的视图
    if (self.isViewLoaded && !self.view.window)
    {
        [self releaseMemory];
    }
}

#pragma mark - UI

- (void)setNavigationBarTitle:(NSString *)title
{
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 0.3;
    fadeTextAnimation.type = kCATransitionFade;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = title;
}

#pragma mark - 释放内存

- (void)releaseMemory
{
    self.view = nil;
}


#pragma mark - 实例方法

- (void)setHeaderWithRefreshingBlock:(void(^)())headerRefreshingBlock
{
    NSMutableArray *propertiesAry = [NSMutableArray array];
    unsigned int count, i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (i = 0; i < count; i ++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertiesAry addObject:propertyName];
    }
    free(properties);
    for (NSString *scrollViewKey in @[@"tableView", @"collectionView"]) {
        if ([propertiesAry containsObject:scrollViewKey]) {
            UIScrollView *scrollView = [self valueForKey:scrollViewKey];
            // 下拉刷新
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerRefreshingBlock];
            [header setTitle:LS(@"下拉可以刷新") forState:MJRefreshStateIdle];
            [header setTitle:LS(@"松开立即刷新") forState:MJRefreshStatePulling];
            [header setTitle:LS(@"正在刷新数据中...") forState:MJRefreshStateRefreshing];
            [header setLastUpdatedTimeText:^NSString *(NSDate *lastUpdatedTime) {
                if (lastUpdatedTime) {
                    // 1.获得年月日
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
                    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
                    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
                    
                    // 2.格式化日期
                    NSString *time = @"";
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    if ([cmp1 day] == [cmp2 day]) { // 今天
                        formatter.dateFormat = LS(@"HH:mm");
                        time = [NSString stringWithFormat:LS(@"今天 %@"), [formatter stringFromDate:lastUpdatedTime]];
                    } else if ([cmp1 year] == [cmp2 year]) { // 今年
                        formatter.dateFormat = @"MM-dd HH:mm";
                        time = [formatter stringFromDate:lastUpdatedTime];
                    } else {
                        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
                        time = [formatter stringFromDate:lastUpdatedTime];
                    }
                    
                    // 3.显示日期
                    return [NSString stringWithFormat:LS(@"最后更新：%@"), time];
                } else {
                    return LS(@"最后更新：无记录");
                }
            }];
            header.stateLabel.font = [UIFont systemFontOfSize:12];
            header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10];
            header.stateLabel.textColor = color_4f331a;
            header.lastUpdatedTimeLabel.textColor = color_4f331a;
            [scrollView setMj_header:header];
            break;
        }
    }
}

- (void)setFooterWithRefreshingBlock:(void(^)())footerRefreshingBlock
{
    NSMutableArray *propertiesAry = [NSMutableArray array];
    unsigned int count, i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (i = 0; i < count; i ++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertiesAry addObject:propertyName];
    }
    free(properties);
    for (NSString *scrollViewKey in @[@"tableView", @"collectionView"]) {
        if ([propertiesAry containsObject:scrollViewKey]) {
            UIScrollView *scrollView = [self valueForKey:scrollViewKey];
            // 上拉刷新
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:footerRefreshingBlock];
            [footer setTitle:LS(@"点击或上拉加载更多") forState:MJRefreshStateIdle];
            [footer setTitle:LS(@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
            [footer setTitle:LS(@"已经全部加载完毕") forState:MJRefreshStateNoMoreData];
            footer.stateLabel.font = [UIFont systemFontOfSize:12];
            footer.stateLabel.textColor = color_4f331a;
            [footer setAutomaticallyHidden:NO];
            [footer setTriggerAutomaticallyRefreshPercent:0];
            [scrollView setMj_footer:footer];
            break;
        }
    }
}

@end
