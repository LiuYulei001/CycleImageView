//
//  CycleImageViewCell.m
//  CycleIMG
//
//  Created by Rainy on 2017/12/28.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "CycleImageViewCell.h"

@interface CycleImageViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CycleImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

@end
