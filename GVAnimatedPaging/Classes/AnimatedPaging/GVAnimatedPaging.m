//
//  GVAnimattedPagging.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVAnimatedPaging.h"
#import "GVHeader.h"

@interface GVAnimatedPaging()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat proportion;
@property (nonatomic, strong) NSArray *headerNames;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GVHeader *header;
@end

@implementation GVAnimatedPaging

- (instancetype)initWithProportion:(CGFloat)proportion andHeaderNames:(NSArray *)names {
    self = [super init];
    if (self) {
        self.proportion = proportion;
        self.headerNames = names;
        
        [self addSubview:self.header];
        [self addSubview:self.scrollView];
        
        self.header.names = self.headerNames;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.header.frame = CGRectMake(0.f,
                                   0.f,
                                   CGRectGetWidth(self.bounds),
                                   CGRectGetHeight(self.bounds) * self.proportion);
    self.scrollView.frame = CGRectMake(0.f,
                                       CGRectGetMaxY(self.header.frame),
                                       CGRectGetWidth(self.bounds),
                                       CGRectGetHeight(self.bounds) - CGRectGetHeight(self.header.bounds));
    
    [self addViewsOverScrollView:self.views];
    NSInteger count = [self.views count];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * count,
                                             CGRectGetHeight(self.scrollView.bounds));
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.header.contentOffsetX = scrollView.contentOffset.x;
}

#pragma mark - Property

- (void)setViews:(NSArray *)views {
    _views = views;
    [self addViewsOverScrollView:_views];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (GVHeader *)header {
    if (!_header) {
        _header = [[GVHeader alloc] initWithFrame:CGRectZero];
    }
    return _header;
}

#pragma mark - Private methods

- (void)addViewsOverScrollView:(NSArray *)views {
    NSUInteger count = [views count];
    for (NSUInteger i = 0; i < count; i++) {
        UIView *view = views[i];
        
        CGRect newFrame = view.frame;
        newFrame.origin.x = CGRectGetWidth(view.bounds) * i;
        view.frame = newFrame;
        [self.scrollView addSubview:view];
    }
}
@end
