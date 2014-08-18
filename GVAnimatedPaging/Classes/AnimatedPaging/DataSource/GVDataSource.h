//
//  GVDataSource.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/16/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GVContainer;

typedef CGFloat(^GVHeaderHeight)(void);
typedef GVContainer* (^GVContainerViewAtIndex)(NSUInteger);
typedef NSUInteger(^GVNumberOfViews)(void);

@interface GVDataSource : NSObject

@property (nonatomic, copy) GVHeaderHeight headerHeightCallblock;
@property (nonatomic, copy) GVContainerViewAtIndex containedViewAtIndexCallblock;
@property (nonatomic, copy) GVNumberOfViews numberOfViewsCallBlock;

@end
