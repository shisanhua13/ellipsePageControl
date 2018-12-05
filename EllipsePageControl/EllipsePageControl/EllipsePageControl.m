//
//  EllipsePageControl.m
//  EllipsePageControl
//
//  Created by ZILIANG HA on 2018/12/5.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "EllipsePageControl.h"

@implementation EllipsePageControl
// 对比两个颜色
-(BOOL)isTheSameColor:(UIColor*)color1 anotherColor:(UIColor*)color2{
    return  CGColorEqualToColor(color1.CGColor, color2.CGColor);
}
#pragma mark - set方法
/** 初始化参数*/
-(void)setOtherColor:(UIColor *)otherColor
{
    if (![self isTheSameColor:otherColor anotherColor:_otherColor]) {
        _otherColor = otherColor;
        [self createPointView];
    }
}
/** 初始化参数*/
-(void)setCurrentColor:(UIColor *)currentColor
{
    if ([self isTheSameColor:currentColor anotherColor:_currentColor]) {
        _currentColor = currentColor;
        [self createPointView];
    }
}
/** 初始化参数*/
-(void)setCurrentBkImg:(UIImage *)currentBkImg
{
    if (_currentBkImg != currentBkImg) {
        _currentBkImg = currentBkImg;
        [self createPointView];
    }
}
/** 初始化参数*/
-(void)setControlSize:(NSInteger)controlSize
{
    if (controlSize != _controlSize) {
        _controlSize = controlSize;
        [self createPointView];
    }
}
/** 初始化参数*/
-(void)setControlSpacing:(NSInteger)controlSpacing
{
    if (controlSpacing != _controlSpacing) {
        _controlSpacing = controlSpacing;
        [self createPointView];
    }
}
/** 初始化参数*/
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (_numberOfPages == numberOfPages) return;
    _numberOfPages = numberOfPages;
    [self createPointView];
}
/** 变动参数*/
-(void)setCurrentPage:(NSInteger)currentPage
{
    if ([self.delegate respondsToSelector:@selector(ellipsePageControlClick:index:)]) {
        [self.delegate ellipsePageControlClick:self index:currentPage];
    }
    
    if (_currentPage == currentPage) return;
    //切换当前的点
    [self exchangeCurrentView:_currentPage new:currentPage];
    _currentPage=currentPage;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    _numberOfPages = 0;
    _currentPage = 0;
    _controlSize = 6;
    _controlSpacing = 8;
    _otherColor = [UIColor grayColor];
    _currentColor = [UIColor orangeColor];
}
#pragma mark - 创建分页点点
-(void)createPointView
{
    //清除self上的所有控件
    [self clearView];
    
    if (_numberOfPages <=0) return;
    // 1、确定起点
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat mainWidth = _numberOfPages *(_controlSize + _controlSpacing);
    //确定起点x
    if (self.frame.size.width < mainWidth) {
        startX = 0;
    } else {
        startX = (self.frame.size.width- mainWidth)/2;
    }
    //确定起点y
    if (self.frame.size.height < _controlSize) {
        startY = 0;
    } else {
        startY = (self.frame.size.height - _controlSize)/2;
    }
    // 2、动态创建点
    for (int page = 0; page < _numberOfPages; page++) {
        
        // 当前点 (椭圆形)
        if (page == _currentPage) {
            UIView *currPointView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _controlSize *2, _controlSize)];
            currPointView.layer.cornerRadius = _controlSize/2;
            currPointView.tag = page + 1000;
            currPointView.backgroundColor = _currentColor;
            currPointView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
            [currPointView addGestureRecognizer:tapGesture];
            [self addSubview:currPointView];
            // 重新记录起点
            startX = CGRectGetMaxX(currPointView.frame) + _controlSpacing;
            // 给当前点点添加图片
            if (_currentBkImg) {
                currPointView.backgroundColor = [UIColor clearColor];
                UIImageView *currBkImg = [UIImageView new];
                currBkImg.tag = 1234;
                currBkImg.frame = currPointView.bounds;
                currBkImg.image=_currentBkImg;
                [currPointView addSubview:currBkImg];
            }
            
            
        } else {//其他的点点
            UIView *otherPointView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _controlSize, _controlSize)];
            otherPointView.backgroundColor = _otherColor;
            otherPointView.tag = page + 1000;
            otherPointView.layer.cornerRadius = _controlSize/2;
            otherPointView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [otherPointView addGestureRecognizer:tapGesture];
            [self addSubview:otherPointView];
            //重新记录起点
            startX=CGRectGetMaxX(otherPointView.frame)+_controlSpacing;
        }
    }
}
#pragma mark - 清除self上的所有控件
-(void)clearView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
#pragma mark - 切换当前的点
-(void)exchangeCurrentView:(NSInteger)old new:(NSInteger)new
{
    // 获取老view
    UIView *oldSelect = [self viewWithTag:1000+old];
    CGRect oldRect = oldSelect.frame;
    // 获取现在view
    UIView *newSelect = [self viewWithTag:1000+new];
    CGRect newRect = newSelect.frame;
    
    // 1、改变图片
    if (_currentBkImg) {
        //移除老的view上面的图片
        UIView *imgview = [oldSelect viewWithTag:1234];
        [imgview removeFromSuperview];
        //在新的view上面添加图片
        newSelect.backgroundColor = [UIColor clearColor];
        UIImageView *currBkImg=[UIImageView new];
        currBkImg.tag = 1234;
        currBkImg.frame = CGRectMake(0, 0, _controlSize *2, _controlSize);
        currBkImg.image = _currentBkImg;
        [newSelect addSubview:currBkImg];
    }
    // 2、改变view的背景颜色
    oldSelect.backgroundColor = _otherColor;
    newSelect.backgroundColor = _currentColor;
    // 3、动画修改有关改动的view的位置
    [UIView animateWithDuration:0.3 animations:^{
        // 1、
        CGFloat lx = oldRect.origin.x;
        if (new < old) {
            lx+=_controlSize;
        }
        oldSelect.frame = CGRectMake(lx, oldRect.origin.y , _controlSize, _controlSize);
        // 2、
        CGFloat mx= newRect.origin.x;
        if(new>old) {
            mx-=_controlSize;
        }
        newSelect.frame=CGRectMake(mx, newRect.origin.y, _controlSize*2, _controlSize);
        // 3、
        // 左边的时候到右边 越过点击
        if (new-old > 1) {
            for (NSInteger t=old+1; t< new; t++)
            {
                UIView *centerView =[self viewWithTag:1000+t];
                centerView.frame = CGRectMake(centerView.frame.origin.x-_controlSize, centerView.frame.origin.y, _controlSize, _controlSize);
            }
        }
        // 4、
        // 右边选中到左边的时候 越过点击
        if(new-old<-1)
        {
            for(NSInteger t=new+1;t<old;t++)
            {
                UIView *centerView=[self viewWithTag:1000+t];
                centerView.frame=CGRectMake(centerView.frame.origin.x+_controlSize, centerView.frame.origin.y, _controlSize, _controlSize);
            }
        }
    }];
}
#pragma mark - 点击点点
-(void)clickAction:(UITapGestureRecognizer *)recognizer
{
    // 1、获取点击”点点“的坐标
    NSInteger index = recognizer.view.tag - 1000;
    NSLog(@"-----:%ld", index);
    // 2、更改当前点点
    [self setCurrentPage:index];
}
@end
