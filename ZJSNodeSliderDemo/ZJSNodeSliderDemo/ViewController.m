//
//  ViewController.m
//  ZJSRangeSlider
//
//  Created by 周建顺 on 2018/7/20.
//  Copyright © 2018年 周建顺. All rights reserved.
//

#import "ViewController.h"
#import "ZJSNodeSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addSlider1];
    [self addSlider2];
}

-(void)addSlider1{
    ZJSNodeSlider *slider = [[ZJSNodeSlider alloc] init];
    slider.frame = CGRectMake(10, 60, CGRectGetWidth(self.view.frame) - 20, 50);
    slider.minValue = 0;
    slider.maxValue = 3;
    slider.step = YES;
    slider.value = 1;
    slider.nodeCount = 4;
    slider.nodeDiameter = 12;
    slider.thumbImage = [UIImage imageNamed:@"icon_device_setting_slider_thumb"];
    slider.backgroundColor = [UIColor yellowColor];
    [slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        slider.value = 3;
    //    });
}

-(void)addSlider2{
    ZJSNodeSlider *slider = [[ZJSNodeSlider alloc] init];
    slider.frame = CGRectMake(10, 120, CGRectGetWidth(self.view.frame) - 20, 50);
    slider.value = 0;
    slider.nodeCount = 0;
    slider.nodeDiameter = 12;
    slider.thumbColor = [UIColor redColor];
    slider.continues = YES;
  //  slider.thumbImage = [UIImage imageNamed:@"icon_device_setting_slider_thumb"];
    slider.backgroundColor = [UIColor yellowColor];
    [slider addTarget:self action:@selector(sliderValueChangedAction2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

-(void)sliderValueChangedAction:(ZJSNodeSlider*)slider{
    NSLog(@"value:%@", @(slider.value));
}

-(void)sliderValueChangedAction2:(ZJSNodeSlider*)slider{
    NSLog(@"value:%@", @(slider.value));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
