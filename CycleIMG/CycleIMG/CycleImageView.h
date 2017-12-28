//
//  CycleImageView.h
//  CycleIMG
//
//  Created by Rainy on 2017/12/28.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CycleImageViewDelegate <NSObject>

@optional
- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface CycleImageView : UIView

@property(nonatomic,weak)id<CycleImageViewDelegate> delegate;

@property(nonatomic,strong)NSArray *images;

@end
