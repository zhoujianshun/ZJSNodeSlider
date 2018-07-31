//
//  ZJSNodeSlider.m
//  ZJSRangeSlider
//
//  Created by 周建顺 on 2018/7/22.
//  Copyright © 2018年 周建顺. All rights reserved.
//

#import "ZJSNodeSlider.h"

@interface ZJSNodeSlider()

@property (nonatomic, strong) CALayer *sliderLine;
@property (nonatomic, strong) CALayer *sliderTrackLine;
@property (nonatomic, strong) CALayer *thumbHandle;


@property (nonatomic, assign) CGFloat barSliderPadding;

@property (nonatomic, strong) NSMutableArray *nodes;

@end

@implementation ZJSNodeSlider{}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    _minValue = 0;
    _maxValue = 1;
    _value = 0;
    _lineHeight = 5;
    
    _thumbColor = [UIColor greenColor];
    _thumbDiameter = 16.f;
    
    _maxValueTintColor = [UIColor grayColor];
    _minValueTintColor = self.tintColor;
    
    _sliderLine = [CALayer layer];
    _sliderLine.backgroundColor = _maxValueTintColor.CGColor;
    [self.layer addSublayer:_sliderLine];
    
    
    _sliderTrackLine = [CALayer layer];
    _sliderTrackLine.backgroundColor = _minValueTintColor.CGColor;
    [self.layer addSublayer:_sliderTrackLine];
    
    
    _thumbHandle = [CALayer layer];
    _thumbHandle.backgroundColor = _thumbColor.CGColor;
    _thumbHandle.cornerRadius = _thumbDiameter/2.f;
    [self.layer addSublayer:_thumbHandle];
    
    _thumbHandle.frame = CGRectMake(0, 0, _thumbDiameter, _thumbDiameter);
    
    
    _nodeCount = 0;
    _nodeDiameter = self.lineHeight +4;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat barSliderPadding = self.barSliderPadding;
    CGRect currentFrame = self.frame;
    CGFloat yMid = CGRectGetHeight(currentFrame)/2.f;
    CGPoint leftSide = CGPointMake(barSliderPadding, yMid - self.lineHeight/2.f);
    CGPoint rightSide = CGPointMake(CGRectGetWidth(currentFrame) - barSliderPadding, yMid - self.lineHeight/2.f);
    
    self.sliderLine.frame = CGRectMake(leftSide.x, leftSide.y, rightSide.x - leftSide.x, self.lineHeight);
    self.sliderLine.cornerRadius = self.lineHeight/2.f;
    
    [self updateUI];
}

-(void)updateUI{
    
    [self updateTrackUI];
    
    [self updateNodes];
}

-(void)updateTrackUI{

    CGFloat percentage = [self percentageWithValue];
    CGFloat lineWidth = CGRectGetWidth(self.sliderLine.frame) ;
    
    // trackLine
    CGFloat width = lineWidth*percentage;
    CGFloat height = CGRectGetHeight(self.sliderLine.frame);
    CGFloat x = CGRectGetMinX(self.sliderLine.frame);
    CGFloat y = CGRectGetMinY(self.sliderLine.frame);
    self.sliderTrackLine.frame = CGRectMake(x, y, width, height);
    self.sliderTrackLine.cornerRadius = self.lineHeight/2.f;
    
    
    // thumb
    CGFloat thumbWidth = CGRectGetWidth(_thumbHandle.frame);
    CGFloat thumbHeight = CGRectGetHeight(_thumbHandle.frame);
    self.thumbHandle.frame = CGRectMake(CGRectGetMaxX(self.sliderTrackLine.frame) - thumbWidth/2.f, CGRectGetMidY(self.sliderTrackLine.frame) - thumbHeight/2.f, thumbWidth, thumbHeight);
}


-(void)updateNodes{
    CGFloat lineWidth = CGRectGetWidth(self.sliderLine.frame);
    
    NSInteger count = self.nodes.count;
    CGFloat distance = lineWidth / (count - 1);
    [self.nodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *layer = obj;
        CGFloat centerX =  idx * distance + CGRectGetMinX(self.sliderLine.frame);
        CGFloat width = self.nodeDiameter;
        CGFloat height = self.nodeDiameter;
        CGFloat x = centerX - width/2.f;
        CGFloat y = CGRectGetMidY(self.sliderLine.frame) - height/2.f;
        layer.frame= CGRectMake(x, y, width, height);
        if (centerX > [self percentageWithValue]*lineWidth) {
            layer.backgroundColor = self.maxValueTintColor.CGColor;
        }else{
            layer.backgroundColor = self.minValueTintColor.CGColor;
        }
        
    }];
}


#pragma mark -

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint startLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(CGRectInset(self.thumbHandle.frame, -10, -10), startLocation)) {
        return YES;
    }
    
    // 支持点击node直接，移动到被点击的node。
    if (self.step) {
        __block CALayer *node ;
        [self.nodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CALayer *layer = obj;
            if (CGRectContainsPoint(CGRectInset(layer.frame, -10, -10), startLocation)) {
                node = layer;
                CGFloat x = CGRectGetMinX(layer.frame) + CGRectGetWidth(layer.frame)/2.f;
                [self updateValueWithPositionX:x];
                
                *stop = YES;
            }
        }];
        
        if (node) {
            [self updateUI];
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:self];
    
    CGFloat x = location.x - self.barSliderPadding;
    BOOL isUpdated = [self updateValueWithPositionX:x];
    
    // 必须要加上Transaction，设置setDisableActions为YES 不然会感觉延迟
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self updateUI];
    [CATransaction commit];
    if (self.continues&&!self.step) {
        
        // 防止多次触发
        if (isUpdated) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (self.step&&self.nodes.count>=2) {
        CGPoint location = [touch locationInView:self];
        CGFloat x = location.x;
        
        CGFloat lineWidth = CGRectGetWidth(self.sliderLine.frame);
        NSInteger nodeCount = self.nodes.count;
        CGFloat distance = lineWidth / (nodeCount - 1);
        
        NSInteger count = x/distance;
        
        if ( (x - count*distance) > distance/2.f) {
            x = (count +1)*distance;
        }else{
            x = count*distance;
        }
        
        [self updateValueWithPositionX:x];
        [self updateUI];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }else{
        if (!self.continues) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
 
}

#pragma mark - private methods

-(NSMutableArray *)nodes{
    if (!_nodes) {
        _nodes = [NSMutableArray array];
    }
    return _nodes;
}

-(CGFloat)percentageWithValue{
    return  (self.value - self.minValue)/( self.maxValue - self.minValue);
}

-(BOOL)updateValueWithPositionX:(CGFloat)x{
    CGFloat percentage = x/CGRectGetWidth(self.sliderLine.frame);
    
    CGFloat value = self.minValue + (self.maxValue - self.minValue) * percentage;;
    if (value > self.maxValue) {
        value = self.maxValue;
    }else if(value < self.minValue){
        value = self.minValue;
    }
    
    if (_value != value) {
        _value = value;
        
        return YES;
    }else{
        return NO;
    }
}

-(CALayer*)createNodeLayer{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = self.maxValueTintColor.CGColor;
    layer.frame = CGRectMake(0, 0, self.nodeDiameter, self.nodeDiameter);
    layer.cornerRadius = self.nodeDiameter/2.f;
    return layer;
}

#pragma mark - getters and setters

-(CGFloat)barSliderPadding{
    return (CGRectGetWidth(self.thumbHandle.frame))/2.f;
}

-(void)setValue:(CGFloat)value{
    if (value > self.maxValue) {
        value = self.maxValue;
    }else if(value < self.minValue){
        value = self.minValue;
    }
    _value = value;
    
    [self setNeedsLayout];
}


-(void)setLineHeight:(CGFloat)lineHeight{
    _lineHeight = lineHeight;
    
    [self setNeedsLayout];
}

-(void)setThumbDiameter:(CGFloat)thumbDiameter{
    _thumbDiameter = thumbDiameter;
    
    [self setNeedsLayout];
}


-(void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
    [self setNeedsLayout];
}

-(void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
    [self setNeedsLayout];
}


-(void)setThumbColor:(UIColor *)thumbColor{
    _thumbColor = thumbColor;
    
    self.thumbHandle.backgroundColor = _thumbColor.CGColor;
}

-(void)setMaxValueTintColor:(UIColor *)maxValueTintColor{
    _maxValueTintColor = maxValueTintColor;
    self.sliderLine.backgroundColor = _maxValueTintColor.CGColor;
}

-(void)setMinValueTintColor:(UIColor *)minValueTintColor{
    _minValueTintColor = minValueTintColor;
    self.sliderTrackLine.backgroundColor = _minValueTintColor.CGColor;
}

-(void)setThumbImage:(UIImage *)thumbImage{
    _thumbImage = thumbImage;
    CGSize size = _thumbImage.size;
    // CGRect startFrame = self.thumbHandle.frame;
    self.thumbHandle.contents = (id)thumbImage.CGImage;
    self.thumbHandle.frame = CGRectMake(0, 0, size.width, size.height);
    self.thumbHandle.backgroundColor = [UIColor clearColor].CGColor;
}

-(void)setNodeCount:(NSInteger)nodeCount{
    if (nodeCount < 1) {
        nodeCount = 0;
    }
    _nodeCount = nodeCount;
    
    [self.nodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *layer = obj;
        [layer removeFromSuperlayer];
    }];
    for (int i = 0; i < nodeCount; i++) {
        CALayer *layer = [self createNodeLayer];
        [self.layer addSublayer:layer];
        [self.nodes addObject:layer];
    }
    
    [self.thumbHandle removeFromSuperlayer];
    [self.layer addSublayer:self.thumbHandle];
    
    [self setNeedsLayout];
}

-(void)setNodeDiameter:(CGFloat)nodeDiameter{
    _nodeDiameter = nodeDiameter;
    [self.nodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *layer = obj;
        layer.cornerRadius = nodeDiameter/2.f;
    }];
    [self setNeedsLayout];
}





@end
