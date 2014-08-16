//
//  GVHeader.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVHeader.h"
#import "GVLabel.h"
#import "GVIndicatorView.h"

#define GVFloatsEqual(_f1, _f2)    (fabs( (_f1) - (_f2) ) < FLT_EPSILON)
#define DEVICE_IS_IPAD ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

@interface GVHeader()
@property (nonatomic, strong) GVIndicatorView *indicatorView;
@property (nonatomic, strong) NSMutableArray *allLabels;
@property (nonatomic, assign) CGFloat headerCenterX;
@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) CGFloat touchedPoint;
@property (nonatomic, assign) CGFloat increment;

@end

@implementation GVHeader

NSString *const kTouchMoved = @"touchesMoved";
NSString *const kAllTouches = @"AllTouches";
NSString *const kFirstTouch = @"FirstTouch";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.indicatorHeight = DEVICE_IS_IPAD ? 20.f : 15.f;
        self.contentOffsetX = 0.f;
        self.increment = 0.f;
        [self addSubview:self.indicatorView];
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
    for (GVLabel *label in self.allLabels) {
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
}

- (GVIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[GVIndicatorView alloc] initWithFrame:CGRectZero];
    }
    return _indicatorView;
}

- (NSMutableArray *)allLabels {
    if (!_allLabels) {
        _allLabels = [NSMutableArray array];
    }
    return _allLabels;
}

#pragma mark - UIPanGestureRecognizer Action method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint firstTouch = [touch locationInView:self];
    self.touchedPoint = firstTouch.x;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    NSValue *value = [NSValue valueWithCGPoint:touchPoint];
    NSDictionary *dictionary = @{kFirstTouch : @(self.touchedPoint),
                                 kAllTouches : value};
    [[NSNotificationCenter defaultCenter] postNotificationName:kTouchMoved object:dictionary];
}

#pragma mark - Private method

- (void)recalculateNewLabelCenter:(CGFloat)offset {
    NSUInteger count = [self.allLabels count];
    
    for (NSUInteger index = 0; index < count; index++) {
        GVLabel *currentLabel = self.allLabels[index];
        CGFloat xDirection = offset - self.lastPosition;
        if (self.velocityValue <= 50) {
            self.headerCenterX -= xDirection/ 2.f + self.increment;
            
            self.increment = 0.f;
        } else if (self.velocityValue > 50) {
            self.increment += 7.f / 16.f * xDirection;
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.headerCenterX -=  xDirection / 16.f;
            //});

        }
        //self.headerCenterX -=  xDirection  / 2.f;
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
    for (NSUInteger index = 0; index < count; index++) {
        GVLabel *label = [[GVLabel alloc] initWithFrame:CGRectZero];
        label.text = labels[index];
        CGFloat fontSize = DEVICE_IS_IPAD ? 28 : 22;
        label.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        [self addSubview:label];
        [self.allLabels addObject:label];
    }
}

- (void)setFrameForEachLabel {
    CGFloat lastLabelWidth = 0.f;
    for (GVLabel *label in self.allLabels) {
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

- (CGFloat)calculateLabelWidth:(GVLabel *)label {
    CGFloat width = CGRectGetWidth(self.bounds) / 2.f;
    if (width > label.intrinsicContentSize.width) {
        return width;
    }
    CGFloat additionalWidth = [self offsetForDynamicWidth:label];
    return label.intrinsicContentSize.width + additionalWidth;
}

- (CGFloat)offsetForDynamicWidth:(GVLabel *)label {
    CGFloat width = CGRectGetWidth(self.bounds) / 2.f;
    CGFloat offset;
    if (width < label.intrinsicContentSize.width) {
        offset = (label.intrinsicContentSize.width - width);
        return offset;
    }
    return 0.f;
}

- (void)defaultValues {
    GVLabel *firstLabel = [self.allLabels firstObject];
    firstLabel.textColor = [UIColor whiteColor];
    self.neighborTitleColor = [UIColor lightGrayColor];
    self.centerTitleColor = [UIColor whiteColor];
}

@end
