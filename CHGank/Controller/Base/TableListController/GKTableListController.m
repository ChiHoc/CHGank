//
//  GKTableListController.m
//  Quketi
//
//  Created by youthmba3 on 16/5/25.
//  Copyright © 2016年 YouthMBA. All rights reserved.
//

#import "GKTableListController.h"
#import "GKPromptView.h"

// Prompt
static const CGFloat kPromptViewMarginLeft = 0.f;
static const CGFloat kPromptViewMarginTop = 0.f;

static NSString *const promptCellIdentifier = @"promptCell";

@interface GKTableListController () <PromptViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) GKPromptView *promptView;

@property (nonatomic, strong) Class listCellClass;

@property (nonatomic, assign) NSInteger listSection;

@end

@implementation GKTableListController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *cellClass = NSStringFromClass([self listCellClass]);
    
    [self.tableView registerNib:[UINib nibWithNibName:cellClass bundle:nil] forCellReuseIdentifier:tableListCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:promptCellIdentifier];
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource:self];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self isHeaderAvailable]) {
        [self setHeaderWithRefreshingBlock:^{
            [weakSelf headerRequestData];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 上拉加载
    if ([self isFooterAvailable]) {
        [self setFooterWithRefreshingBlock:^{
            [weakSelf footerRequestData];
        }];
    }
    
    [self.tableView.mj_footer setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - 方法重写

- (BOOL)isHeaderAvailable
{
    return YES;
}

- (BOOL)isFooterAvailable
{
    return YES;
}

#pragma mark - 属性方法

- (GKPromptView *)promptView
{
    if (!_promptView) {
        self.promptView = [[GKPromptView alloc] initWithFrame:CGRectMake(kPromptViewMarginLeft,
                                                                          kPromptViewMarginTop,
                                                                          screenWidth(),
                                                                          [GKPromptView height])];
        [_promptView setHidden:YES];
        [_promptView setDelegate:self];
    }
    return _promptView;
}

#pragma mark - 公有方法

- (Class)listCellClass
{
    return [UITableViewCell class];
}

- (NSInteger)listSection
{
    return 0;
}

- (NSString *)emptyLabelText
{
    return LS(@"列表为空");
}

- (GKListDataSource *)dataSource
{
    CHLogError();
    return nil;
}

#pragma mark - TableView重写方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndex:(NSInteger)index
{
    return [[self listCellClass] height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView listCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableListCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndex:(NSInteger)index
{
    return;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndex:(NSInteger)index
{
    if (self.dataSource.data.count) {
        return YES;
    }
    return NO;
}

- (void)resetHeaderFooter
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listSection == indexPath.section) {
        if ([self.dataSource.data count]) {
            return [self tableView:tableView heightForRowAtIndex:indexPath.row];
        } else {
            return [GKPromptView height];
        }
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.listSection) {
        return [self tableView:tableView shouldHighlightRowAtIndex:indexPath.row];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == self.listSection && [self.dataSource.data count]) {
        [self tableView:tableView didSelectRowAtIndex:indexPath.row];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.listSection) {
        if (![self.dataSource.data count]) {
//            [tableView setSeparatorColor:[UIColor clearColor]];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            if (self.dataSource.isLoadAll) {
                return 0;
            } else {
                return 1;
            }
        }
//        [tableView setSeparatorColor:color_d3ccc6];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return [self.dataSource.data count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.listSection) {
        if (self.dataSource.data.count) {
            UITableViewCell *cell = [self tableView:tableView listCellAtIndex:indexPath.row];
            
            if (indexPath.row == [self.dataSource.data count] - 1 &&
                !self.dataSource.isLoadAll &&
                !self.tableView.mj_footer.isHidden) {
                [self.tableView.mj_footer beginRefreshing];
            }
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:promptCellIdentifier];
            [cell setBackgroundColor:color_fffcf2];
            if (self.promptView.superview != cell) {
                [self.promptView removeFromSuperview];
                [cell.contentView addSubview:self.promptView];
            }
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}

#pragma mark - 网络请求

/**
 *  下拉请求数据
 */
- (void)headerRequestData
{
    [self.tableView.mj_footer setHidden:YES];
    [self.promptView setHidden:YES];
    [self.dataSource requestData:YES];
}

/**
 *  上拉请求数据
 */
- (void)footerRequestData
{
    [self.tableView.mj_header setHidden:YES];
    [self.dataSource requestData:NO];
}

#pragma mark - GKListDataSourceDelegate

- (void)dataSourceDidReceiveResponse:(GKListDataSource *)dataSource
{
    [self resetHeaderFooter];
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header setHidden:NO];
}

- (void)dataSourceDidFailedToRequestData:(GKListDataSource *)dataSource;
{
    if (![dataSource.data count]) {
        [self.promptView setHidden:NO];
        [self.tableView.mj_footer setHidden:YES];
    }
}

- (void)dataSourceDidRefreshData:(GKListDataSource *)dataSource
{
    [self.tableView reloadData];
}

- (void)dataSource:(GKListDataSource *)dataSource didAddDataWithStart:(NSInteger)start length:(NSInteger)length
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:length];
    for (NSInteger row = 0; row < length; row ++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:start + row inSection:self.listSection]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dataSourceDidLoadAllData:(GKListDataSource *)dataSource
{
    [self.tableView.mj_footer setHidden:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"bg_icon_0"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.emptyLabelText;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName:color_c4bbb2};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return ![self.dataSource.data count] && self.dataSource.isLoadAll;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -30.f;
}

#pragma mark - PromptViewDelegate

- (void)onPromptViewDidPressed
{
    [self.tableView.mj_header beginRefreshing];
}


@end
