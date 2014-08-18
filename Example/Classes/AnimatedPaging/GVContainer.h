//
//  GVContainer.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 16/08/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVContainer : NSObject

- (instancetype)initWithHeaderText:(NSAttributedString *)attributedString
                        linkedView:(UIView *)linkedView;

@property (nonatomic, copy, readonly) NSAttributedString *attributedString;
@property (nonatomic, strong, readonly) UIView *linkedView;

@end
