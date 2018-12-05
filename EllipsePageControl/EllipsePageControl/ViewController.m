//
//  ViewController.m
//  EllipsePageControl
//
//  Created by ZILIANG HA on 2018/12/4.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "ViewController.h"
#import "EllipsePageControl.h"
@interface ViewController ()<EllipsePageControlDelegate>
@property(nonatomic,strong) EllipsePageControl *myPageControl1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myPageControl1 = [[EllipsePageControl alloc] init];
    _myPageControl1.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 30);
    _myPageControl1.numberOfPages = 6;
    _myPageControl1.delegate = self;
    _myPageControl1.tag = 111;
    _myPageControl1.controlSize = 20;
    _myPageControl1.currentBkImg = [UIImage imageNamed:@"lunbochangtu"];
    [self.view addSubview:_myPageControl1];
    _myPageControl1.backgroundColor = [UIColor redColor];
}
#pragma  mark EllipsePageControlDelegate。监听用户点击
-(void)ellipsePageControlClick:(EllipsePageControl *)pageControl index:(NSInteger)clickIndex
{
    NSLog(@"%ld",clickIndex);
}

@end
