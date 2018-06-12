//
//  ViewController.m
//  CycleIMG
//
//  Created by Rainy on 2017/12/28.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "ViewController.h"
#import "CycleImageView.h"

@interface ViewController ()<CycleImageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CycleImageView *cycleImageView = [[CycleImageView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200)];
    cycleImageView.images = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
    cycleImageView.delegate = self;
    
    
    CycleImageView *cycleImageView2 = [[CycleImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleImageView.frame) + 30, self.view.bounds.size.width, 200)];
    cycleImageView2.movementDirection = MovementDirectionVertically;
    cycleImageView2.timeInterval = 0.5;
    cycleImageView2.images = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
    cycleImageView2.hidePageControl = YES;
    cycleImageView2.canFingersSliding = NO;
    
    
    [self.view addSubview:cycleImageView];
    [self.view addSubview:cycleImageView2];
}

#pragma mark - CycleImageViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
