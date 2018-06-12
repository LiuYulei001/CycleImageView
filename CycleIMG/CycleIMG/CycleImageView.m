//
//  CycleImageView.m
//  CycleIMG
//
//  Created by Rainy on 2017/12/28.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#define kPageControl_H      40

#define kCellIdentifier     @"CycleImageViewCell"

#import "CycleImageView.h"
#import "CycleImageViewCell.h"
#import "CycleImageViewPageControl.h"

@interface CycleImageView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _index;
    BOOL _isScrol;
    UICollectionViewScrollPosition _scrollPosition;
    UICollectionViewScrollDirection _scrollDirection;
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CycleImageViewPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation CycleImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.movementDirection = MovementDirectionForHorizontally;
        
    }
    return self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.image = self.images[indexPath.row];
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_isScrol) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:_scrollPosition animated:NO];
        _isScrol = NO;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = 0;
    
    if (!self.movementDirection) {
        
        currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
        
    } else
    {
        currentPage = scrollView.contentOffset.y / scrollView.bounds.size.height;
    }
    
    currentPage = currentPage % self.images.count;
    
    self.pageControl.currentPage = currentPage;
    _index = currentPage;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:1] atScrollPosition:_scrollPosition animated:NO];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - timer action
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.timeInterval ? self.timeInterval : 1) target:self selector:@selector(timerCycleImageAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)timerCycleImageAction:(NSTimer *)timer
{
    if (_index == self.images.count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:_scrollPosition animated:YES];
        self.pageControl.currentPage = 0;
        _index = 1;
        _isScrol = YES;
        
    }else
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:1] atScrollPosition:_scrollPosition animated:YES];
        self.pageControl.currentPage = _index;
        _index += 1;
    }
}
#pragma mark - setter
- (void)setMovementDirection:(MovementDirectionType)movementDirection
{
    _movementDirection = movementDirection;
    
    if (!movementDirection) {
        
        _scrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
        _scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }else
    {
        _scrollPosition = UICollectionViewScrollPositionCenteredVertically;
        _scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}
- (void)setImages:(NSArray *)images
{
    _images = images;
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = images.count;
    [self startTimer];
}
- (void)setHidePageControl:(BOOL)hidePageControl
{
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = hidePageControl;
}
- (void)setCanFingersSliding:(BOOL)canFingersSliding
{
    _canFingersSliding = canFingersSliding;
    self.collectionView.scrollEnabled = canFingersSliding;
}
#pragma mark - getter
- (CycleImageViewPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[CycleImageViewPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - kPageControl_H, self.bounds.size.width, kPageControl_H)];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.enabled = NO;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        flowLayout.scrollDirection = _scrollDirection;
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionView];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:_scrollPosition animated:NO];
        
    }
    return _collectionView;
}
#pragma mark - dealloc
- (void)dealloc
{
    [self stopTimer];
}

@end
