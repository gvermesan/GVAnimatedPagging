//
//  GVAnimattedPagging.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVAnimatedPaging.h"
#import "GVHeader.h"

#define GVFloatsEqual(_f1, _f2)    (fabs( (_f1) - (_f2) ) < FLT_EPSILON)

@interface GVAnimatedPaging()<UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *headerNames;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GVHeader *header;

@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, strong) UIView *containedView;

@property (nonatomic, strong) NSMutableOrderedSet *allViews;


@end

@implementation GVAnimatedPaging

NSString *const kTouchMovedNotified = @"touchesMoved";
NSString *const kAllTouchesNotified = @"AllTouches";
NSString *const kFirstTouchNotified = @"FirstTouch";

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithHeaderText:(NSAttributedString *)attributedString andContainedView:(UIView *)view {
    NSParameterAssert(attributedString.length);
    NSParameterAssert(view);
    
    self = [super init];
    if (self) {
        self.attributedString = attributedString;
        self.containedView = view;
        
        [self.allViews addObject:view];
        
        [self defaultValues];
    }
    return self;
}


- (void)reload {
    NSParameterAssert(self.numberOfViewsCallBlock);
    NSParameterAssert(self.containedViewAtIndexCallblock);

    self
    NSInteger count = self.numberOfViewsCallBlock();
    for (NSUInteger index = 0;index < count; index++) {
        GVContainer *container = self.containedViewAtIndexCallblock(index);
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.header.frame = CGRectMake(0.f,
                                   0.f,
                                   CGRectGetWidth(self.bounds),
                                   self.headerHeight);
    self.scrollView.frame = CGRectMake(0.f,
                                       CGRectGetMaxY(self.header.frame),
                                       CGRectGetWidth(self.bounds),
                                       CGRectGetHeight(self.bounds) - CGRectGetHeight(self.header.bounds));
    
    [self addViewsOverScrollView:self.allViews];
    NSInteger count = [self.allViews count];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * count,
                                             CGRectGetHeight(self.scrollView.bounds));
    
    
    
}

#pragma NSNotificationCenter method

- (void)headerTouched:(NSNotification *)notif {
    NSDictionary *dict = notif.object;
    NSValue *value = dict[kAllTouchesNotified];
    CGPoint currentTouchPoint = [value CGPointValue];
    CGFloat firstTouchX = [dict[kFirstTouchNotified] floatValue];
   
    BOOL flag = (currentTouchPoint.x < firstTouchX);
    
    NSUInteger currentPage = flag ? (self.scrollView.contentOffset.x / CGRectGetWidth(self.bounds)) + 1 :
                                    ceilf((self.scrollView.contentOffset.x / CGRectGetWidth(self.bounds))) - 1;

    CGFloat newContentOffsetX = flag ? currentPage * CGRectGetWidth(self.bounds) - currentTouchPoint.x :
                                       (currentPage + 1) * CGRectGetWidth(self.bounds) - currentTouchPoint.x;
    
    if (self.scrollView.contentOffset.x + CGRectGetWidth(self.bounds) >= self.scrollView.contentSize.width && flag) {
        currentPage -= 1;
        return;
    }
    
    if (newContentOffsetX  < 0 && !flag) {
        return;
    }
    
    self.scrollView.contentOffset = CGPointMake(newContentOffsetX, 0.f);
    [self.scrollView scrollRectToVisible:CGRectMake(currentPage * CGRectGetWidth(self.bounds),
                                                    0.f,
                                                    CGRectGetWidth(self.bounds),
                                                    CGRectGetHeight(self.scrollView.bounds))
                                animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.header.contentOffsetX = scrollView.contentOffset.x;
    self.header.velocityValue = fabsf([[scrollView panGestureRecognizer] velocityInView:self].x);
}


#pragma mark - Property

- (void)setHeaderHeight:(CGFloat)headerHeight {
    if (GVFloatsEqual(_headerHeight, headerHeight)) {
        return;
    }
    _headerHeight = headerHeight;
    [self setNeedsLayout];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor lightGrayColor];
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

- (void)addViewsOverScrollView:(NSMutableOrderedSet *)views {
    NSUInteger count = [views count];
    for (NSUInteger i = 0; i < count; i++) {
        UIView *view = views[i];
        
        CGRect newFrame = view.frame;
        newFrame.origin.x = CGRectGetWidth(view.bounds) * i;
        view.frame = newFrame;
        [self.scrollView addSubview:view];
    }
}

- (void)defaultValues {
    self.headerHeight = 60.f;
}

@end
