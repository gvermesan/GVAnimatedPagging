//
//  GVAnimatedPaggingTests.m
//  GVAnimatedPaggingTests
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "GVMainViewController.h"
#import "GVAnimatedPaging.h"
#import "GVContainer.h"
#import "GVScrollView.h"

@interface GVAnimatedPaging ()

- (void)scrollToContainer:(GVContainer *)container;

@end

@interface GVAnimatedPaggingTests : XCTestCase

@property (nonatomic, strong) GVMainViewController *mainViewController;

@end

@implementation GVAnimatedPaggingTests

- (void)setUp {
    [super setUp];
    self.mainViewController = [[GVMainViewController alloc] initWithNibName:nil bundle:nil];
    
    //Load the view
    __unused UIView *view = self.mainViewController.view;
}

- (void)tearDown {
    self.mainViewController = nil;
    [super tearDown];
}

- (void)testViewController {
    XCTAssert(self.mainViewController, @"A view controller should be instantiated");
    XCTAssert(self.mainViewController.isViewLoaded, @"Its view should be loaded");
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}

- (void)testRedView {
    GVAnimatedPaging *animatedPagging = self.mainViewController.animatedPaging;
    XCTAssert(animatedPagging, "Animated pagging view should exist by now");
    
    NSArray *allContainers = self.mainViewController.containers;
    XCTAssert(allContainers.count, @"There should be at least one container");
    
    NSUInteger secondIndex = 1U;
    GVContainer *redContainer = allContainers[secondIndex];
    XCTAssertEqualObjects(redContainer.attributedString.string, @"Red View");
    XCTAssertEqualObjects([redContainer.linkedView class], [UIView class]);
    XCTAssertEqual(redContainer.linkedView.backgroundColor, [UIColor redColor]);
}

- (void)testScrollToThirdContainer {
    GVAnimatedPaging *animatedPagging = self.mainViewController.animatedPaging;
    XCTAssert(animatedPagging, "Animated pagging view should exist by now");
    
    NSArray *allContainers = self.mainViewController.containers;
    XCTAssert(allContainers.count, @"There should be at least one container");
    
    NSUInteger thirdIndex = 2U;
    GVContainer *thirdContainer = allContainers[thirdIndex];
    XCTAssert(thirdContainer, @"Should be a container");
    
    [animatedPagging scrollToContainer:thirdContainer];
    XCTAssertEqualObjects(thirdContainer.attributedString.string, @"#2 TableView");
    XCTAssertEqualObjects([thirdContainer.linkedView class], [UITableView class]);

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}

- (void)testScrollThroughFourthContainer {
    GVAnimatedPaging *animatedPagging = self.mainViewController.animatedPaging;
    XCTAssert(animatedPagging, "Animated pagging view should exist by now");
    
    NSArray *allContainers = self.mainViewController.containers;
    XCTAssert(allContainers.count, @"There should be at least one container");
    
    NSUInteger fourthIndex = 3U;
    GVContainer *fourthContainer = allContainers[fourthIndex];
    XCTAssert(fourthContainer, @"Should be a container");
    
    [animatedPagging scrollToContainer:fourthContainer];
    XCTAssertNotEqualObjects(fourthContainer.attributedString.string, @"#2 TableView");
    XCTAssertNotEqualObjects([fourthContainer.linkedView class], [UITableView class]);
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}


@end
