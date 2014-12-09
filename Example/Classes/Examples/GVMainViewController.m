//
//  GVMainViewController.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVMainViewController.h"
#import "GVAnimatedPaging.h"
#import "GVContainer.h"
#include "GVDataSource.h"
#include "GVIndicatorView.h"
#include "GVHeader.h"
#import "GVScrollView.h"

#define DEVICE_IS_IPAD ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

@interface GVMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite, strong) GVAnimatedPaging *animatedPaging;
@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;
@property (nonatomic, strong) UITableView *tableview3;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *purpleView;

@property (nonatomic, strong) NSMutableArray *allContainers;


@end

@implementation GVMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Animated Paging";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.allContainers = [NSMutableArray array];

    self.tableview1 = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    
    NSAttributedString *firstAttributtedString = [[NSAttributedString alloc] initWithString:@"#1 TableView"];
    GVContainer *firstContainer = [[GVContainer alloc] initWithHeaderText:firstAttributtedString
                                                               linkedView:self.tableview1];
    [self.allContainers addObject:firstContainer];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redView.backgroundColor = [UIColor redColor];
    
    NSAttributedString *secondAttributtedString = [[NSAttributedString alloc] initWithString:@"Red View"];
    GVContainer *secondContainer = [[GVContainer alloc] initWithHeaderText:secondAttributtedString
                                                               linkedView:self.redView];
    [self.allContainers addObject:secondContainer];
    
    self.tableview2 = [[UITableView alloc] initWithFrame:CGRectZero
                                                                  style:UITableViewStylePlain];

    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    NSAttributedString *thirdAttributtedString = [[NSAttributedString alloc] initWithString:@"#2 TableView"];
    GVContainer *thirdContainer = [[GVContainer alloc] initWithHeaderText:thirdAttributtedString
                                                                linkedView:self.tableview2];
    [self.allContainers addObject:thirdContainer];
    
    self.greenView = [[UIView alloc] initWithFrame:CGRectZero];
    self.greenView.backgroundColor = [UIColor greenColor];
   
    NSAttributedString *fourthAttributtedString = [[NSAttributedString alloc] initWithString:@"Green View"];
    GVContainer *fourthContainer = [[GVContainer alloc] initWithHeaderText:fourthAttributtedString
                                                                linkedView:self.greenView];
    [self.allContainers addObject:fourthContainer];
    
    
    GVDataSource *dataSource = [GVDataSource new];
    dataSource.numberOfViewsCallBlock = ^() {
        return [self.allContainers count];
    };
    
    dataSource.containedViewAtIndexCallblock = ^(NSUInteger index) {
        
        GVContainer *container = self.allContainers[index];
        return container;
    };
    
    dataSource.headerHeightCallblock = ^() {
        return 60.f;
    };
    
    self.animatedPaging = [[GVAnimatedPaging alloc] initWithFrame:self.view.bounds andDataSource:dataSource];

    [self.view addSubview:self.animatedPaging];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    GVContainer *container = self.allContainers[1];
    [self.animatedPaging scrollToContainer:container];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.animatedPaging.frame = self.view.bounds;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableview1]) {
        return 9;
    }
    return 19;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"k2";
    if ([tableView isEqual:self.tableview1]) {
        identifier = @"k1";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"This is a simple example.";
    return cell;
}

#pragma mark - Public methods

- (NSArray *)containers {
    return [NSArray arrayWithArray:self.allContainers];
}

@end
