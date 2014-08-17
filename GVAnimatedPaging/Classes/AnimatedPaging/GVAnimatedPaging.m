//
//  GVAnimattedPagging.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVAnimatedPaging.h"
#import "GVHeader.h"
#import "GVDataSource.h"
#import "GVContainer.h"

#define GVFloatsEqual(_f1, _f2)    (fabs( (_f1) - (_f2) ) < FLT_EPSILON)

@interface GVAnimatedPaging()<UIScrollViewDelegate>

@property (nonatomic, strong) GVDataSource *dataSource;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *headerNames;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GVHeader *header;

@property (nonatomic, strong) NSMutableArray *allAttributedStrings;
@property (nonatomic, strong) NSMutableArray *allViews;
@property (nonatomic, assign) CGFloat headerHeight;


@end

@implementation GVAnimatedPaging

NSString *const kTouchMovedNotified = @"TouchesMoved";
NSString *const kAllTouchesNotified = @"AllTouches";
NSString *const kFirstTouchNotified = @"FirstTouch";

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
                andDataSource:(GVDataSource *)dataSource {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        [self addSubview:self.header];
        [self addSubview:self.scrollView];
        
        [self reload];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerTouched:) name:kTouchMovedNotified object:nil];
    }
    return self;
}

- (void)reload {
    NSParameterAssert(self.dataSource.numberOfViewsCallBlock);
    NSParameterAssert(self.dataSource.containedViewAtIndexCallblock);

    [self.allViews removeAllObjects];
    [self.allAttributedStrings removeAllObjects];
    
    NSInteger count = self.dataSource.numberOfViewsCallBlock();
    for (NSUInteger index = 0; index < count; index++) {
        GVContainer *container = self.dataSource.containedViewAtIndexCallblock(index);
        [self.allViews addObject:container.linkedView];
        [self.allAttributedStrings addObject:container.attributedString];
    }
    [self addViewsOverScrollView:self.allViews];
    self.header.names = self.allAttributedStrings;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headerHeight = self.dataSource.headerHeightCallblock();
    
    self.header.frame = CGRectMake(0.f,
                                   0.f,
                                   CGRectGetWidth(self.bounds),
                                   self.headerHeight);
    self.scrollView.frame = CGRectMake(0.f,
                                       CGRectGetMaxY(self.header.frame),
                                       CGRectGetWidth(self.bounds),
                                       CGRectGetHeight(self.bounds) - CGRectGetHeight(self.header.bounds));
    [self reload];
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

- (NSMutableArray *)allViews {
    if (!_allViews) {
        _allViews = [NSMutableArray array];
    }
    return _allViews;
}

- (NSMutableArray *)allAttributedStrings {
    if (!_allAttributedStrings) {
        _allAttributedStrings = [NSMutableArray array];
    }
    return _allAttributedStrings;
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

- (void)defaultValues {
    self.headerHeight = 60.f;
}

@end
