//
//  GVContainer.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 16/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVContainer.h"
#import "GVAnimatedPaging.h"

@interface GVContainer ()

@property (nonatomic, copy, readwrite) NSAttributedString *attributedString;
@property (nonatomic, strong, readwrite) UIView *linkedView;

@end

@implementation GVContainer

- (instancetype)initWithHeaderText:(NSAttributedString *)attributedString
                        linkedView:(UIView *)linkedView {
    
    NSParameterAssert(attributedString.length);
    NSParameterAssert(linkedView);
    self = [super init];
    if (self) {
        self.attributedString = attributedString;
        self.linkedView = linkedView;
    }
    return self;
}

@end
