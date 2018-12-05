//
//  EllipsePageControl.h
//  EllipsePageControl
//
//  Created by ZILIANG HA on 2018/12/5.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EllipsePageControl;
@protocol EllipsePageControlDelegate <NSObject>
-(void)ellipsePageControlClick:(EllipsePageControl *)pageControl
                         index:(NSInteger)clickIndex;
@end


@interface EllipsePageControl : UIControl
/* 分页数量*/
@property (nonatomic, assign) NSInteger numberOfPages;
/* 当前点所在下标*/
@property (nonatomic, assign) NSInteger currentPage;
/* 点的大小*/
@property (nonatomic, assign) NSInteger controlSize;
/* 点的间距*/
@property (nonatomic, assign) NSInteger controlSpacing;
/* 其他未选中点颜色*/
@property (nonatomic, strong) UIColor *otherColor;
/* 当前点颜色*/
@property (nonatomic, strong) UIColor *currentColor;
/* 当前点背景图片*/
@property(nonatomic,strong) UIImage *currentBkImg;
@property (nonatomic, weak) id<EllipsePageControlDelegate> delegate;
@end

