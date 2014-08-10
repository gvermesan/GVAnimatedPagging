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

@interface GVHeader()
@property (nonatomic, strong) GVIndicatorView *indicatorView;
@property (nonatomic, assign) CGFloat headerCenterX;
@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, strong) NSMutableArray *allLabels;

@end

@implementation GVHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.contentOffsetX = 0.f;
        self.indicatorHeight = 12.f;
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
    NSUInteger count = [self.allLabels count];
    
    for (NSUInteger i = 0; i< count; i++) {
        GVLabel *label = self.allLabels[i];
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

#pragma mark - Private method

- (void)recalculateNewLabelCenter:(CGFloat)offset {
    NSUInteger count = [self.allLabels count];
    for (NSUInteger i = 0; i < count; i++) {
        
        GVLabel *previousLabel = self.allLabels[i];
        if (i + 1 < count) {
            GVLabel * currentLabel = self.allLabels[i + 1];
            CGFloat distanceBetweenLabelCenters = (currentLabel.center.x - previousLabel.center.x);
            CGFloat xDirection = offset - self.lastPosition;
            self.headerCenterX -= xDirection / 3.f;
            self.lastPosition = offset;
        }
        if (CGRectGetWidth(self.indicatorView.bounds) / 2.f >= CGRectGetMinX(previousLabel.frame) &&
            CGRectGetWidth(self.indicatorView.bounds) / 2.f < CGRectGetMaxX(previousLabel.frame)) {
            previousLabel.textColor = [UIColor whiteColor];
        } else {
            previousLabel.textColor = [UIColor lightGrayColor];
        }
        
    }
}

- (void)createLabelsForHeader:(NSArray *)labels {
    NSUInteger count = [labels count];
    for (NSUInteger i = 0; i < count; i++) {
        GVLabel *label;
        label = [[GVLabel alloc] initWithFrame:CGRectZero];
        label.text = labels[i];
        [self addSubview:label];
        [self.allLabels addObject:label];
    }
}

- (void)setFrameForEachLabel {
    CGFloat lastLabelWidth = 0.f;
    NSUInteger count = [self.allLabels count];
    for (NSUInteger i = 0; i < count; i++) {
        GVLabel *label = self.allLabels[i];
        CGFloat width = [self calculateLabelWidth:label];
        CGFloat offsetX = self.headerCenterX + (CGRectGetWidth(self.bounds) - width) / 2.f;
        label.frame = CGRectMake(offsetX + lastLabelWidth,
                                 0.0,
                                 width,
                                 CGRectGetHeight(self.bounds));
        NSLog(@"Origin %f", CGRectGetMinX(label.frame));
        lastLabelWidth += CGRectGetWidth(label.bounds);
    }
}

- (CGFloat)calculateLabelWidth:(GVLabel *)label {
    CGFloat width = CGRectGetWidth(self.bounds) / 3.f;
    if (width > label.intrinsicContentSize.width) {
        return width;
    }
    return label.intrinsicContentSize.width;
}

- (void)defaultValues {
    GVLabel *firstLabel = [self.allLabels firstObject];
    firstLabel.textColor = [UIColor whiteColor];
}

@end
