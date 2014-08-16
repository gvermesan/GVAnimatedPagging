//
//  GVContainer.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 16/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVContainer.h"
#import "GVAnimatedPaging.h"


#define GVFloatsEqual(_f1, _f2)    (fabs( (_f1) - (_f2) ) < FLT_EPSILON)

@interface GVContainer ()

@property (nonatomic, strong, readwrite) UIView *headerView;
@property (nonatomic, strong, readwrite) UIView *linkedView;

@end

@implementation GVContainer

- (instancetype)initWithHeaderView:(UIView *)headerView
                        linkedView:(UIView *)linkedView {
    
    NSParameterAssert(headerView);
    NSParameterAssert(linkedView);
    self = [super init];
    if (self) {
        self.headerView = headerView;
        self.linkedView = linkedView;
    }
    return self;
}

@end
