//
//  GVHeader.h
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

@import UIKit;

@class GVIndicatorView;

typedef void(^GVHeaderStateChanged)(NSDictionary *);
typedef void(^GVHeaderStateFinished)(CGFloat);

@interface GVHeader : UIView

@property (nonatomic, readonly, strong) GVIndicatorView *indicatorview;

@property (nonatomic, strong) NSArray *names;

//Header title properties
@property (nonatomic, strong) UIFont *headerNameFont UI_APPEARANCE_SELECTOR; //Default is Helvetica with 28 for iPad and 22 for iPhone
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) CGFloat indicatorHeight;      // Set the indicator view height. Default is 20 for iPad and 15 for iPhone
@property (nonatomic, strong) UIColor *centerTitleColor;    // Set the color to the current view title. Default is whiteColor
@property (nonatomic, strong) UIColor *neighborTitleColor;  // Set the color to the neighbours of the center title. Default is lightGrey color


@property (nonatomic, assign) CGFloat contentOffsetX; // This property is used to animate the header text, Shouldn not be modified
@property (nonatomic, assign) CGFloat velocityValue; // This property is used to animate the header text, Shouldn not be modified

//Blocks propertis
@property (nonatomic, copy) GVHeaderStateChanged stateChanged;
@property (nonatomic, copy) GVHeaderStateFinished stateFinished;

@end
