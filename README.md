# CycleImageView
基于UICollectionView封装高性能轮播图

涉及控件：

UICollectionView、UICollectionViewCell、UIPageControl、NSTimer

用法：

导入头文件#import "CycleImageView.h"

如需点击事件需实现<CycleImageViewDelegate>代理协议

创建：

CycleImageView *cycleImageView = [[CycleImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)];

cycleImageView.images = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];

cycleImageView.delegate = self;

[self.view addSubview:cycleImageView];

代理：

#pragma mark - CycleImageViewDelegate

- (void)didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}
