//
//  ViewController.m
//  CustomSliderViewDemo
//
//  Created by FengLing on 16/2/4.
//  Copyright © 2016年 lk. All rights reserved.
//

#import "ViewController.h"
#import "CustomSliderView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomSliderView *slider = [[CustomSliderView alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-10, 50)];
    slider.value = 6;
    [self.view addSubview:slider];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
