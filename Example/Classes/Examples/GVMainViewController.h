//
//  GVMainViewController.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GVAnimatedPaging;

@interface GVMainViewController : UIViewController

//Just for the Unit Tests
@property (nonatomic, readonly, strong) GVAnimatedPaging *animatedPaging;
- (NSArray *)containers;

@end
