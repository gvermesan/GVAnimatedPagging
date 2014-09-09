//
//  GVHeader.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVHeader.h"
#import "GVIndicatorView.h"

#define GVFloatsEqual(_f1, _f2)    (fabs( (_f1) - (_f2) ) < FLT_EPSILON)
#define DEVICE_IS_IPAD ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

@interface GVHeader() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) GVIndicatorView *indicatorView;
@property (nonatomic, strong) NSMutableArray *allLabels;
@property (nonatomic, assign) CGFloat headerCenterX;
@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) CGFloat touchedPoint;
@property (nonatomic, assign) CGFloat increment;

@end

@implementation GVHeader

NSString *const kAllTouches = @"AllTouches";
NSString *const kFirstTouch = @"FirstTouch";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.indicatorHeight = DEVICE_IS_IPAD ? 20.f : 15.f;
        self.contentOffsetX = 0.f;
        self.increment = 0.f;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setFrameForEachLabel];
    self.indicatorView.frame = CGRectMake(0.f,
                                          CGRectGetHeight(self.bounds) - self.indicatorHeight,
                                          CGRectGetWidth(self.bounds),
                                          self.indicatorHeight);
}

#pragma mark - Property

- (void)setNames:(NSArray *)names {
    if ([_names isEqualToArray:names]) {
        return;
    }
    _names = names;
    [self createLabelsForHeader:_names];
    [self defaultValues];
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    if ([_attributedString isEqualToAttributedString:attributedString]) {
        return;
    }
    _attributedString = attributedString;
    for (UILabel *label in self.allLabels) {
        label.attributedText = _attributedString;
    }
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    if (GVFloatsEqual(_indicatorHeight, indicatorHeight)) {
        return;
    }
    _indicatorHeight = indicatorHeight;
    [self setNeedsLayout];
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    if (GVFloatsEqual(_contentOffsetX, contentOffsetX)) {
        return;
    }
    _contentOffsetX = contentOffsetX;
    [self recalculateNewLabelCenter:_contentOffsetX];
    [self setNeedsLayout];
}

- (void)setHeaderNameFont:(UIFont *)headerNameFont {
    if ([_headerNameFont isEqual:headerNameFont]) {
        return;
    }
    _headerNameFont = headerNameFont;
    for (UILabel *label in self.allLabels) {
        label.font = _headerNameFont;
    }
}

- (void)setCenterTitleColor:(UIColor *)centerTitleColor {
    if ([_centerTitleColor isEqual:centerTitleColor]) {
        return;
    }
    _centerTitleColor = centerTitleColor;
    UILabel *firstLabel = [self.allLabels firstObject];
    firstLabel.textColor = _centerTitleColor;
}

- (GVIndicatorView *)indicatorView {
    if (!_indicatorView) {
        CGRect frame = CGRectMake(0.f,
                                  CGRectGetHeight(self.bounds) - self.indicatorHeight,
                                  CGRectGetWidth(self.bounds),
                                  self.indicatorHeight);
        _indicatorView = [[GVIndicatorView alloc] initWithFrame:frame];
    }
    return _indicatorView;
}

- (NSMutableArray *)allLabels {
    if (!_allLabels) {
        _allLabels = [NSMutableArray array];
    }
    return _allLabels;
}

#pragma mark - UIPanGestureRecognizer action methods

- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.touchedPoint = [gesture locationInView:self].x;
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handleChangeState:gesture];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self handleFinishedState:gesture];
            break;
            
        default:
            break;
    }
}


#pragma mark - Private method

- (void)handleChangeState:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    NSValue *value = [NSValue valueWithCGPoint:touchPoint];
    NSDictionary *dictionary = @{kFirstTouch : @(self.touchedPoint),
                                 kAllTouches : value};
    if (self.stateChanged) {
        self.stateChanged(dictionary);
    }
}

- (void)handleFinishedState:(UIPanGestureRecognizer *)gesture {
    CGFloat endPoint = [gesture locationInView:self].x;
    CGFloat addToContentOffset = CGRectGetWidth(self.bounds) - (self.touchedPoint - endPoint);
    if (self.touchedPoint < endPoint) {
        addToContentOffset = (endPoint - self.touchedPoint + 0.5) - CGRectGetWidth(self.bounds);
    }
    if (self.stateFinished) {
        self.stateFinished(addToContentOffset);
    }
}

- (void)recalculateNewLabelCenter:(CGFloat)offset {
    NSUInteger count = [self.allLabels count];
    
    for (NSUInteger index = 0; index < count; index++) {
        UILabel *currentLabel = self.allLabels[index];
        CGFloat xDirection = offset - self.lastPosition;
        self.headerCenterX -=  xDirection  / 2.f;
        self.lastPosition = offset;
        
        if (CGRectGetWidth(self.indicatorView.bounds) / 2.f >= CGRectGetMinX(currentLabel.frame) &&
            CGRectGetWidth(self.indicatorView.bounds) / 2.f < CGRectGetMaxX(currentLabel.frame)) {
            currentLabel.textColor = self.centerTitleColor;
        } else {
            currentLabel.textColor = self.neighborTitleColor;
        }
    }
}

- (void)createLabelsForHeader:(NSArray *)labels {
    NSUInteger count = [labels count];
    [self.allLabels removeAllObjects];
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    for (NSUInteger index = 0; index < count; index++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self defaultsValuesForLabel:label];
        label.attributedText = labels[index];
        CGFloat fontSize = DEVICE_IS_IPAD ? 28 : 22;
        label.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:label];
        [self.allLabels addObject:label];
    }
    [self addSubview:self.indicatorView];
}

- (void)setFrameForEachLabel {
    CGFloat lastLabelWidth = 0.f;
    for (UILabel *label in self.allLabels) {
        CGFloat width = [self calculateLabelWidth:label];
        CGFloat offsetForDinamicWidth = [self offsetForDynamicWidth:label];
        CGFloat offsetX = self.headerCenterX +
                          offsetForDinamicWidth +
                          (CGRectGetWidth(self.bounds) - width) / 2.f;
        label.frame = CGRectMake(offsetX + lastLabelWidth,
                                 0.0,
                                 width,
                                 CGRectGetHeight(self.bounds));
        lastLabelWidth += CGRectGetWidth(label.bounds);
    }
}


/* ToDo: Animate the header labels when the text is higher than the half of the screen */
- (CGFloat)calculateLabelWidth:(UILabel *)label {
    CGFloat width = CGRectGetWidth(self.bounds) / 2.f;
    return width;
}

- (CGFloat)offsetForDynamicWidth:(UILabel *)label {
    return 0.f;
}

- (void)defaultValues {
    UILabel *firstLabel = [self.allLabels firstObject];
    self.neighborTitleColor = [UIColor lightGrayColor];
    self.centerTitleColor = [UIColor whiteColor];
    firstLabel.textColor = self.centerTitleColor;
}

- (void)defaultsValuesForLabel:(UILabel *)label {
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
}

@end
