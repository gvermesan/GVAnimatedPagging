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
#import "GVAnimattedPagging.h"

#define GVFloatsEqual(_f1, _f2)    (fabs( (_f1) - (_f2) ) < FLT_EPSILON)

@interface GVHeader()
@property (nonatomic, strong) GVIndicatorView *indicatorView;
@property (nonatomic, strong) GVLabel *leftHeaderName;
@property (nonatomic, strong) GVLabel *middleHeaderName;
@property (nonatomic, strong) GVLabel *rightHeaderName;
@end

@implementation GVHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.contentOffsetX = 0.f;
        [self addSubview:self.leftHeaderName];
        [self addSubview:self.middleHeaderName];
        [self addSubview:self.rightHeaderName];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftHeaderName.frame = CGRectMake(-self.contentOffsetX,
                                           0.0,
                                           CGRectGetWidth(self.bounds) / 3.f,
                                           CGRectGetHeight(self.bounds));
    self.middleHeaderName.frame = CGRectMake(CGRectGetMaxX(self.leftHeaderName.frame),
                                             0.0,
                                             CGRectGetWidth(self.bounds) / 3.f,
                                             CGRectGetHeight(self.bounds));
    
    self.rightHeaderName.frame = CGRectMake(CGRectGetMaxX(self.middleHeaderName.frame),
                                             0.0,
                                             CGRectGetWidth(self.bounds) / 3.f,
                                             CGRectGetHeight(self.bounds));
    CGFloat indicatorHeight = 10.f;
    self.indicatorView.frame = CGRectMake(0.f,
                                          CGRectGetHeight(self.bounds) - indicatorHeight,
                                          CGRectGetWidth(self.bounds),
                                          indicatorHeight);
}

#pragma mark - Property

- (void)setNames:(NSArray *)names {
    if ([_names isEqualToArray:names]) {
        return;
    }
    _names = names;
    self.leftHeaderName.text = _names[0];
    self.middleHeaderName.text = _names[1];
    self.rightHeaderName.text = _names[2];
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    if (GVFloatsEqual(_contentOffsetX, contentOffsetX)) {
        return;
    }
    _contentOffsetX = contentOffsetX;
    [self setNeedsLayout];
}

- (void)setHeaderNameFont:(UIFont *)headerNameFont {
    if ([_headerNameFont isEqual:headerNameFont]) {
        return;
    }
    _headerNameFont = headerNameFont;
    self.leftHeaderName.font =
    self.middleHeaderName.font =
    self.rightHeaderName.font = _headerNameFont;
}

- (GVLabel *)leftHeaderName {
    if (!_leftHeaderName) {
        _leftHeaderName = [[GVLabel alloc] initWithFrame:CGRectZero];
    }
    return _leftHeaderName;
}

- (GVLabel *)middleHeaderName {
    if (!_middleHeaderName) {
        _middleHeaderName = [[GVLabel alloc] initWithFrame:CGRectZero];
    }
    return _middleHeaderName;
}

- (GVLabel *)rightHeaderName {
    if (!_rightHeaderName) {
        _rightHeaderName = [[GVLabel alloc] initWithFrame:CGRectZero];
    }
    return _rightHeaderName;
}

- (GVIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[GVIndicatorView alloc] initWithFrame:CGRectZero];
    }
    return _indicatorView;
}

@end
