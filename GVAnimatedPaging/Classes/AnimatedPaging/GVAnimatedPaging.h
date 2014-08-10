//
//  GVAnimattedPagging.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;

@interface GVAnimatedPaging : UIView

- (instancetype)initWithProportion:(CGFloat)proportion andHeaderNames:(NSArray *)names;

@property (nonatomic, strong) NSArray *views;

//Header properties
@property (nonatomic, strong) UIFont  *headerNameFont;
@property (nonatomic, strong) UIColor *headerBackgroundColor;
@property (nonatomic, strong) UIColor *indicatorBackgroundColor;
@property (nonatomic, assign) CGFloat indicatorSide;

@end
