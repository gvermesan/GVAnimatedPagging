//
//  GVHeader.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;

@class GVIndicatorView;
@interface GVHeader : UIView

@property (nonatomic, readonly, strong) GVIndicatorView *indicatorview;

@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) UIFont *headerNameFont;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) CGFloat indicatorHeight;

//Scroll properties
@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat scrollOffset;
@property (nonatomic, assign, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, assign) CGFloat velocityValue;

@end
