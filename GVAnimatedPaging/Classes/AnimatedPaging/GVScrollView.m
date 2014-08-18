//
//  GVScrollView.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 18/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVScrollView.h"

@interface GVScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation GVScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.delegate = self;
        
        [self addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addViewsOverScrollView:self.allViews];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        
    }
}

#pragma mark - Setter methods

- (void)setAllViews:(NSArray *)allViews {
    if ([_allViews isEqualToArray:allViews]) {
        return;
    }
    _allViews = allViews;
    [self addViewsOverScrollView:_allViews];
}

#pragma mark - UIScrolViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDelegateValues) {
        CGFloat velocity = [[scrollView panGestureRecognizer] velocityInView:self].x;
        self.scrollViewDelegateValues(scrollView.contentOffset.x, velocity);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.bounds);
}

#pragma mark - private methods

- (void)addViewsOverScrollView:(NSArray *)views {
    NSUInteger count = [views count];
    for (NSUInteger i = 0; i < count; i++) {
        UIView *view = views[i];
        
        CGRect newFrame = view.frame;
        newFrame.origin.x = CGRectGetWidth(view.bounds) * i;
        newFrame.origin.y = 0.f;
        newFrame.size.width = CGRectGetWidth(self.bounds);
        newFrame.size.height = CGRectGetHeight(self.bounds);
        view.frame = newFrame;
        if (![[self subviews] containsObject:view]) {
            [self addSubview:view];
        }
    }
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * count,
                                  CGRectGetHeight(self.bounds));
}

@end
