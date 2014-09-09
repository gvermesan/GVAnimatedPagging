//
//  GVAnimattedPagging.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVAnimatedPaging.h"
#import "GVScrollView.h"
#import "GVHeader.h"
#import "GVDataSource.h"
#import "GVContainer.h"

#define GVWeakSelf  __weak typeof(self) weakSelf = self

@interface GVAnimatedPaging()<UIScrollViewDelegate>

@property (nonatomic, strong) GVDataSource *dataSource;
@property (nonatomic, strong) GVScrollView *scrollView;
@property (nonatomic, strong) GVHeader *header;

@property (nonatomic, strong) NSMutableArray *allAttributedStrings;
@property (nonatomic, strong) NSMutableArray *allViews;
@property (nonatomic, assign) CGFloat headerHeight;


@end

@implementation GVAnimatedPaging

NSString *const kAllTouchesNotified = @"AllTouches";
NSString *const kFirstTouchNotified = @"FirstTouch";

- (instancetype)initWithFrame:(CGRect)frame
                andDataSource:(GVDataSource *)dataSource {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        self.headerHeight = self.dataSource.headerHeightCallblock();
        
        [self addSubview:self.header];
        [self addSubview:self.scrollView];
        
        [self defaultValues];
        [self reloadData];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.header.frame = [self frameForHeader];
    self.scrollView.frame = [self frameForScrollView];
    
    [self.scrollView addViewsOverScrollView:self.allViews];
}

#pragma mark - Public methods

- (void)reloadData {
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
    self.scrollView.allViews = self.allViews;
    self.header.names = self.allAttributedStrings;
}

- (void)scrollToContainer:(GVContainer *)container {
    NSParameterAssert(container);
    
    NSUInteger index = [self.allViews indexOfObject:container.linkedView];
    
    NSAssert(index, @"Container at your index was not found!");
    self.scrollView.currentPage = index;
}

#pragma mark - Property

- (GVScrollView *)scrollView {
    if (!_scrollView) {
        GVWeakSelf;
        CGRect rect = [self frameForScrollView];
        
        _scrollView = [[GVScrollView alloc] initWithFrame:rect];
        _scrollView.scrollViewDelegateValues = ^(CGPoint contentOffset, CGFloat velocity) {
            CGFloat contentOffsetX = contentOffset.x;
            weakSelf.header.contentOffsetX = contentOffsetX;
            weakSelf.header.velocityValue = velocity;
            if (weakSelf.dataSource.pageDidScroll) {
                weakSelf.dataSource.pageDidScroll(contentOffset);
            }
        };
    }
    return _scrollView;
}

- (GVHeader *)header {
    if (!_header) {
        GVWeakSelf;
        CGRect rect = [self frameForHeader];
        
        _header = [[GVHeader alloc] initWithFrame:rect];
        _header.stateChanged = ^(NSDictionary *dictionary) {
            [weakSelf headerTouched:dictionary];
        };
        
        _header.stateFinished = ^(CGFloat xCoord) {
            weakSelf.scrollView.currentPage = (weakSelf.scrollView.contentOffset.x + xCoord) / CGRectGetWidth(weakSelf.scrollView.bounds);
        };
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

- (void)headerTouched:(NSDictionary *)dict {
    NSValue *value = dict[kAllTouchesNotified];
    CGPoint currentTouchPoint = [value CGPointValue];
    CGFloat firstTouchX = [dict[kFirstTouchNotified] floatValue];
    
    BOOL flag = (currentTouchPoint.x < firstTouchX);
    
    NSUInteger currentPage = flag ? (self.scrollView.contentOffset.x / CGRectGetWidth(self.bounds)) + 1 :
                                    ceilf((self.scrollView.contentOffset.x / CGRectGetWidth(self.bounds))) - 1;
    
    CGFloat newContentOffsetX = flag ? currentPage * CGRectGetWidth(self.bounds) - currentTouchPoint.x - (CGRectGetWidth(self.bounds) - firstTouchX):
                                       (currentPage + 1) * CGRectGetWidth(self.bounds) - currentTouchPoint.x + firstTouchX;
    
    if (self.scrollView.contentOffset.x + CGRectGetWidth(self.bounds) >= self.scrollView.contentSize.width && flag) {
        currentPage -= 1;
        return;
    }
    
    if (self.scrollView.contentOffset.x <= 0 && !flag) {
        return;
    }
    
    self.scrollView.contentOffset = CGPointMake(newContentOffsetX, 0.f);
    [self.scrollView scrollRectToVisible:CGRectMake(currentPage * CGRectGetWidth(self.bounds),
                                                    0.f,
                                                    CGRectGetWidth(self.bounds),
                                                    CGRectGetHeight(self.scrollView.bounds))
                                animated:YES];
}

- (void)defaultValues {
    self.layer.masksToBounds = YES;
}

#pragma mark - Frame methods

- (CGRect)frameForHeader {
    CGRect frame = CGRectMake(0.f,
                              0.f,
                              CGRectGetWidth(self.bounds),
                              self.headerHeight);
    return frame;
}

- (CGRect)frameForScrollView {
    CGRect frame = CGRectMake(0.f,
                              CGRectGetMaxY(self.header.frame),
                              CGRectGetWidth(self.bounds),
                              CGRectGetHeight(self.bounds) - CGRectGetHeight(self.header.bounds));
    return frame;
}



@end
