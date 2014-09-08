//
//  GVScrollView.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 18/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GVScrollViewDelegateValues)(CGPoint, CGFloat);

@interface GVScrollView : UIScrollView

@property (nonatomic, strong) NSArray *allViews;
@property (nonatomic, copy) GVScrollViewDelegateValues scrollViewDelegateValues;

@property (nonatomic, assign) NSUInteger currentPage;

- (void)addViewsOverScrollView:(NSArray *)views;

@end
