//
//  GVAnimattedPagging.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;
@class GVHeader;
@class GVContainer;
@class GVDataSource;

@interface GVAnimatedPaging : UIView

- (instancetype)initWithFrame:(CGRect)frame
                andDataSource:(GVDataSource *)dataSource;

@property (nonatomic, strong, readonly) GVDataSource *dataSource;

- (void)reloadData;

@end
