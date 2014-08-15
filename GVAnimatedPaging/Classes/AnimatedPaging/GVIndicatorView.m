//
//  GVIndicatorView.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVIndicatorView.h"

@implementation GVIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.indicatorFillColor = [UIColor darkGrayColor];
        self.indicatorFrameColor = [UIColor blackColor];
    }
    return self;
}

-  (void)setIndicatorFillColor:(UIColor *)indicatorFillColor {
    if ([_indicatorFillColor isEqual:indicatorFillColor]) {
        return;
    }
    _indicatorFillColor = indicatorFillColor;
    [self setNeedsDisplay];
}

- (void)setIndicatorFrameColor:(UIColor *)indicatorFrameColor {
    if ([_indicatorFrameColor isEqual:indicatorFrameColor]) {
        return;
    }
    _indicatorFrameColor = indicatorFrameColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIColor *fillColor = self.indicatorFillColor;
    [fillColor setFill];
    
    UIColor *strokeColor = self.indicatorFrameColor;
    [strokeColor setStroke];
    
    CGFloat sideWidth = 2 * CGRectGetHeight(self.bounds) / sqrtf(3.f);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:1.F];
    
    [bezierPath moveToPoint:CGPointMake(0.f, CGRectGetHeight(self.bounds))];
    [bezierPath addLineToPoint:CGPointMake((CGRectGetWidth(self.bounds) - sideWidth) / 2.f, CGRectGetHeight(self.bounds))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) / 2.f, 0.f)];
    [bezierPath addLineToPoint:CGPointMake((CGRectGetWidth(self.bounds) + sideWidth) / 2.f, CGRectGetHeight(self.bounds))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [bezierPath moveToPoint:CGPointMake(0.f, CGRectGetHeight(self.bounds))];
    [bezierPath closePath];
    [bezierPath fill];
    [bezierPath stroke];
}

@end
