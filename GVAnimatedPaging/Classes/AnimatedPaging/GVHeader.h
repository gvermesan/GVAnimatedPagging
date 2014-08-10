//
//  GVHeader.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;

@interface GVHeader : UIView

@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) UIFont *headerNameFont;
@property (nonatomic, strong) UIColor *indicatorBackgroundColor;
@property (nonatomic, assign) CGFloat contentOffsetX;
@end
