//
//  GVContainer.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 16/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVContainer : NSObject

- (instancetype)initWithHeaderView:(UIView *)headerView
                        linkedView:(UIView *)linkedView;

@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, strong, readonly) UIView *linkedView;

@end
