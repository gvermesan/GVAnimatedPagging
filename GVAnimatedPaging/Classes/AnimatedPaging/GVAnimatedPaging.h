//
//  GVAnimattedPagging.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;
@class GVHeader;

@interface GVAnimatedPaging : UIView

- (instancetype)initWithProportion:(CGFloat)proportion andHeaderNames:(NSArray *)names;

@property (nonatomic, readonly, strong) GVHeader *header;
@property (nonatomic, strong) NSArray *views;

@end
