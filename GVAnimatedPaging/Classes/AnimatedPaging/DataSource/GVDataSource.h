//
//  GVDataSource.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/16/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GVContainer;

typedef CGFloat(^HeaderHeight)(void);
typedef GVContainer* (^ContainerViewAtIndex)(NSUInteger);
typedef NSUInteger(^NumberOfViews)(void);
typedef void(^ReloadData)();

@interface GVDataSource : NSObject

@property (nonatomic, copy) HeaderHeight headerHeightCallblock;
@property (nonatomic, copy) ContainerViewAtIndex containedViewAtIndexCallblock;
@property (nonatomic, copy) NumberOfViews numberOfViewsCallBlock;
@property (nonatomic, copy) ReloadData reloadDataCallBlock;

@end
