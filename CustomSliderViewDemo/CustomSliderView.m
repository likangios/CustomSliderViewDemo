//
//  CustomSliderView.m
//  ddd
//
//  Created by FengLing on 16/2/4.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "CustomSliderView.h"

@interface CustomSliderView ()<UIGestureRecognizerDelegate>
{
    int  btnCount;//按钮个数
    
    int  btnSpace;//按钮之间间隙
}
@property (nonatomic,strong) UIView *clipView;

@property (nonatomic,strong) UIImageView *touchView;

@end

@implementation CustomSliderView

-(instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        
        btnCount = 10;//小按钮的个数
        
        //        默认灰色图片
        UIImage *BottomLineImg = [UIImage imageNamed:@"btn_jian_gray"];
        //        高亮图片
        UIImage *TopLineImg = [UIImage imageNamed:@"btn_jian_red"];
        //        拖动按钮图片
        UIImage *TouchBtnImg = [UIImage imageNamed:@"btn_yuan"];
        //        中间小按钮图片
        //        UIImage *BtnsImg = [UIImage imageNamed:@""];
        //        UIImage *BtnHightlightImg = [UIImage imageNamed:@""];
        
        UIImageView *bottomImageview = [[UIImageView alloc]init];
        bottomImageview.image = BottomLineImg;
        bottomImageview.bounds = CGRectMake(0, 0, frame.size.width-TouchBtnImg.size.width, 2);
        bottomImageview.center = CGPointMake(CGRectGetWidth(frame)/2.0, CGRectGetHeight(frame)/2.0);
        [self addSubview:bottomImageview];
        
        _clipView = [[UIView alloc]initWithFrame:CGRectMake(bottomImageview.frame.origin.x, bottomImageview.frame.origin.y,0, CGRectGetHeight(bottomImageview.frame))];
        _clipView.clipsToBounds = YES;
        [self addSubview:_clipView];
        
        UIImageView *topImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(bottomImageview.frame), CGRectGetHeight(bottomImageview.frame))];
        topImageview.image = TopLineImg;
        [_clipView addSubview:topImageview];
        
        btnSpace = (frame.size.width-TouchBtnImg.size.width)/(btnCount-1);
        for (int i = 0; i<btnCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.bounds = CGRectMake(0, 0, 13, 13);
            btn.center = CGPointMake(TouchBtnImg.size.width/2.0+btnSpace*i, frame.size.height/2.0);
            btn.tag = i+1;
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            btn.layer.borderWidth = 3.0;
            btn.layer.cornerRadius = CGRectGetWidth(btn.frame)/2.0;
            btn.layer.masksToBounds = YES;
            //            [btn setImage:BtnsImg forState:UIControlStateNormal];
            //            [btn setImage:BtnHightlightImg forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        _touchView = [[UIImageView alloc]init];
        _touchView.bounds = CGRectMake(0, 0, TouchBtnImg.size.width, TouchBtnImg.size.height);
        _touchView.center = CGPointMake(TouchBtnImg.size.width/2.0, frame.size.height/2.0);
        _touchView.image = TouchBtnImg;
        _touchView.backgroundColor = [UIColor clearColor];
        _touchView.userInteractionEnabled = YES;
        [self addSubview:_touchView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewpan:)];
        [_touchView addGestureRecognizer:pan];
    }
    return self;
}
//TouchView 手势处理
- (void)TouchViewpan:(UIPanGestureRecognizer *)pan{
    
    CGPoint  point = [pan locationInView:self.touchView];
    CGFloat  origin_x = self.touchView.frame.origin.x;
    
    origin_x  += point.x;
    origin_x = MIN(origin_x, self.frame.size.width-CGRectGetWidth(self.touchView.frame)/2.0);
    origin_x = MAX(origin_x, CGRectGetWidth(self.touchView.frame)/2.0);
    
    self.touchView.center = CGPointMake(origin_x, self.touchView.center.y);
    
    _clipView.frame = CGRectMake(_clipView.frame.origin.x, _clipView.frame.origin.y,CGRectGetMinX(self.touchView.frame), _clipView.frame.size.height);
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        [self UpdateTouchViewOriginX:[self getTouchViewOriginX]];
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        [self setBtnSelected:self.touchView.frame.origin.x/btnSpace+1];
        
    }
}
// 计算 touchView 最接近按钮的位置
- (CGFloat)getTouchViewOriginX{
    
    CGFloat  touchConstant = self.touchView.frame.origin.x;
    CGFloat Space = btnSpace/2.0;
    CGFloat  count = touchConstant/Space;
    NSInteger  index = ceil(count/2.0);
    //
    [self setBtnSelected:index];
    return index*btnSpace;
}
// 小按钮点击
- (void)BtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    [self UpdateTouchViewOriginX:(tag-1)*btnSpace];
    [self setBtnSelected:tag];
}

//更新TouchView
- (void)UpdateTouchViewOriginX:(CGFloat)constant{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.touchView.frame = CGRectMake(constant,CGRectGetMinY(self.touchView.frame), CGRectGetWidth(self.touchView.frame), CGRectGetHeight(self.touchView.frame));
        _clipView.frame = CGRectMake(_clipView.frame.origin.x, _clipView.frame.origin.y,CGRectGetMinX(self.touchView.frame), _clipView.frame.size.height);
    } completion:^(BOOL finished) {
        NSLog(@"constant  is %f tag is %.0f",constant,constant/btnSpace);
    }];
}
//更新小按钮
- (void)setBtnSelected:(NSInteger)tag{
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i+1];
        if (i<tag) {
            btn.backgroundColor = [UIColor redColor];
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}
// 属性设置 点击第几个按钮
- (void)setValue:(CGFloat)value{
    value = MIN(value, btnCount-1);
    value = MAX(value, 0);
    [self UpdateTouchViewOriginX:value*btnSpace];
    [self setBtnSelected:value];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
