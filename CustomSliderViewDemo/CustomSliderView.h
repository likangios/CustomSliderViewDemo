//
//  CustomSliderView.h
//  ddd
//
//  Created by FengLing on 16/2/4.
//  Copyright © 2016年 lk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSliderViewDelegate <NSObject>

- (void)SliderValue:(CGFloat)value;

@end

@interface CustomSliderView : UIView

@property (nonatomic,weak) id <CustomSliderViewDelegate> delegate;

/**
 *  显示到第几个按钮 从0开始 0~（btnCount-1）
 */
@property (nonatomic,assign) CGFloat  value;

@end
