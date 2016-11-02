//
//  GKCollectionListController.m
//  Quketi
//
//  Created by ChiHo on 11/26/15.
//  Copyright © 2015 YouthMBA. All rights reserved.
//

#import "GKCollectionListController.h"
#import "GKPromptView.h"

// Prompt
static const CGFloat kPromptViewMarginLeft = 0.f;
static const CGFloat kPromptViewMarginTop = 0.f;

static NSString *const PromptCellIdentifier = @"promptCell";

@interface GKCollectionListController () <PromptViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) GKPromptView *promptView;

@property (nonatomic, strong) Class listCellClass;

@property (nonatomic, assign) NSInteger listSection;

@end

@implementation GKCollectionListController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *cellClass = NSStringFromClass([self listCellClass]);
    
    [self.collectionView setEmptyDataSetSource:self];
    [self.collectionView setEmptyDataSetDelegate:self];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:cellClass bundle:nil] forCellWithReuseIdentifier:collectionListCellIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PromptCellIdentifier];
    
    __weak typeof(self) weakSelf = self;
    
    if ([self isHeaderAvailable]) {
        [self setHeaderWithRefreshingBlock:^{
            [weakSelf headerRequestData];
        }];
        [self.collectionView.mj_header beginRefreshing];
    }
    
    // 上拉加载
    if ([self isFooterAvailable]) {
        [self setFooterWithRefreshingBlock:^{
            [weakSelf footerRequestData];
        }];
    }
    
    [self.collectionView.mj_footer setHidden:YES];
    
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

#pragma mark - 公有方法

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
    return [UICollectionViewCell class];
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

/**
 *  重置HeaderFooter
 */
- (void)resetHeaderFooter
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - CollectionView重写方法

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView listCellAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:self.listSection];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ListCellIdentifier
                                                                           forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndex:(NSInteger)index
{
    return CGSizeMake((screenWidth() - 36.f) / 2 , 0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndex:(NSInteger)index
{
    if (self.dataSource.data.count) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index
{
    return;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    if (section == self.listSection) {
        if (![self.dataSource.data count]) {
            if (self.dataSource.isLoadAll) {
                return 0;
            } else {
                return 1;
            }
        }
        return [self.dataSource.data count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listSection == indexPath.section) {
        if ([self.dataSource.data count]) {
            UICollectionViewCell *cell = [self collectionView:collectionView listCellAtIndex:indexPath.row];
            
            if (indexPath.row == [self.dataSource.data count] - 1 &&
                !self.self.dataSource.isLoadAll &&
                !self.collectionView.mj_footer.isHidden) {
                [self.collectionView.mj_footer beginRefreshing];
            }
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PromptCellIdentifier
                                                                                   forIndexPath:indexPath];
            [cell setBackgroundColor:color_fffcf2];
            if (self.promptView.superview != cell) {
                [self.promptView removeFromSuperview];
                [cell.contentView addSubview:self.promptView];
            }
            return cell;
        }
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.listSection) {
        return [self collectionView:collectionView shouldHighlightItemAtIndex:indexPath.row];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.section == self.listSection && [self.dataSource.data count]) {
        [self collectionView:collectionView didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([self.dataSource.data count]) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.listSection) {
        if ([self.dataSource.data count]) {
            return [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndex:indexPath.row];
        } else {
            return CGSizeMake(screenWidth(), [GKPromptView height]);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - 网络请求

/**
 *  下来请求数据
 */
- (void)headerRequestData
{
    [self.collectionView.mj_footer setHidden:YES];
    [self.promptView setHidden:YES];
    [self.dataSource requestData:YES];
}

/**
 *  上拉请求数据
 */
- (void)footerRequestData
{
    [self.collectionView.mj_header setHidden:YES];
    [self.dataSource requestData:NO];
}

#pragma mark - GKListDataSourceDelegate

- (void)dataSourceDidReceiveResponse:(GKListDataSource *)dataSource
{
    [self resetHeaderFooter];
    [self.collectionView.mj_footer setHidden:NO];
    [self.collectionView.mj_header setHidden:NO];
}

- (void)dataSourceDidFailedToRequestData:(GKListDataSource *)dataSource;
{
    if (![dataSource.data count]) {
        [self.promptView setHidden:NO];
        [self.collectionView.mj_footer setHidden:YES];
    }
}

- (void)dataSourceDidRefreshData:(GKListDataSource *)dataSource
{
    [self.collectionView reloadData];
}

- (void)dataSource:(GKListDataSource *)dataSource didAddDataWithStart:(NSInteger)start length:(NSInteger)length
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:length];
    for (NSInteger row = 0; row < length; row ++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:start + row inSection:self.listSection]];
    }
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)dataSourceDidLoadAllData:(GKListDataSource *)dataSource
{
    [self.collectionView.mj_footer setHidden:YES];
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

#pragma mark - PromptViewDelegate

- (void)onPromptViewDidPressed
{
    [self.collectionView.mj_header beginRefreshing];
}

@end
