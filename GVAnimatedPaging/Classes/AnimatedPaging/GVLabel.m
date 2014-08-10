//
//  GVLabel.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVLabel.h"

@implementation GVLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
