//
//  GVAnimattedPagging.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;
@class GVHeader;
@class GVContainer;

typedef CGFloat(^HeaderHeight)(void);
typedef GVContainer* (^ContainerViewAtIndex)(NSUInteger);
typedef NSInteger(^NumberOfViews)(void);


@interface GVAnimatedPaging : UIView

- (instancetype)initWithHeaderText:(NSAttributedString *)attributedString andContainedView:(UIView *)view;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, copy) HeaderHeight headerHeightCallblock;
@property (nonatomic, copy) ContainerViewAtIndex containedViewAtIndexCallblock;
@property (nonatomic, copy) NumberOfViews numberOfViewsCallBlock;

- (void)reload;

@end
