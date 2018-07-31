//
//  ZJSNodeSlider.h
//  ZJSRangeSlider
//
//  Created by 周建顺 on 2018/7/22.
//  Copyright © 2018年 周建顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSNodeSlider : UIControl

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, getter=isContinuous) BOOL continues;
@property (nonatomic, assign) BOOL step;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, strong) UIImage *thumbImage;;
@property (nonatomic, assign) CGFloat thumbDiameter;
@property (nonatomic, strong) UIColor *thumbColor;

@property (nonatomic, strong) UIColor *maxValueTintColor;
@property (nonatomic, strong) UIColor *minValueTintColor;


@property (nonatomic, assign) CGFloat lineHeight;


@property (nonatomic, assign) NSInteger nodeCount;
@property (nonatomic, assign) CGFloat nodeDiameter;



@end
