//
//  GVDataSource.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/16/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GVContainer;

typedef float(^GVHeaderHeight)(void);
typedef GVContainer* (^GVContainerViewAtIndex)(NSUInteger);
typedef NSUInteger(^GVNumberOfViews)(void);
typedef void (^GVPageDidScroll)(CGPoint);

@interface GVDataSource : NSObject

@property (nonatomic, copy) GVHeaderHeight headerHeightCallblock;
@property (nonatomic, copy) GVContainerViewAtIndex containedViewAtIndexCallblock;
@property (nonatomic, copy) GVNumberOfViews numberOfViewsCallBlock;
@property (nonatomic, copy) GVPageDidScroll pageDidScroll;

@end
