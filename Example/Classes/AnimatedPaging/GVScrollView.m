//
//  GVScrollView.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 18/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVScrollView.h"

@interface GVScrollView () <UIScrollViewDelegate>

@end

@implementation GVScrollView

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.delegate = self;
        
        [self addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewToRectWithAnimation:NO];
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

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    _currentPage = currentPage;
    [self scrollViewToRectWithAnimation:YES];
}

#pragma mark - UIScrolViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDelegateValues) {
        CGFloat velocity = fabsf([[scrollView panGestureRecognizer] velocityInView:self].x);
        self.scrollViewDelegateValues(scrollView.contentOffset, velocity);
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
        newFrame = CGRectMake(CGRectGetWidth(self.bounds) * i,
                              0.f,
                              CGRectGetWidth(self.bounds),
                              CGRectGetHeight(self.bounds));
        view.frame = newFrame;
        if (![[self subviews] containsObject:view]) {
            [self addSubview:view];
        }
    }
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * count,
                                CGRectGetHeight(self.bounds));
}

- (void)scrollViewToRectWithAnimation:(BOOL)animated {
    CGRect frame = CGRectMake(self.currentPage * CGRectGetWidth(self.bounds),
                              0.f,
                              CGRectGetWidth(self.bounds),
                              CGRectGetHeight(self.bounds));
    [self scrollRectToVisible:frame animated:animated];
}

@end
