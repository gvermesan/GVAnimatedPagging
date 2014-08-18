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

#define DEVICE_IS_IPAD ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

@interface GVMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GVAnimatedPaging *animatedPaging;
@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;
@property (nonatomic, strong) UITableView *tableview3;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *purpleView;

@property (nonatomic, strong) NSMutableArray *allViews;
@property (nonatomic, strong) NSMutableArray *allAttributedStrings;

@end

@implementation GVMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Animated Paging";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.allViews = [NSMutableArray array];
    self.allAttributedStrings = [NSMutableArray array];

    self.tableview1 = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    [self.allViews addObject:self.tableview1];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redView.backgroundColor = [UIColor redColor];
    [self.allViews addObject:self.redView];
    
    self.tableview2 = [[UITableView alloc] initWithFrame:CGRectZero
                                                                  style:UITableViewStylePlain];

    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    [self.allViews addObject:self.tableview2];
    
    self.greenView = [[UIView alloc] initWithFrame:CGRectZero];
    self.greenView.backgroundColor = [UIColor greenColor];
    [self.allViews addObject:self.greenView];
    
    self.tableview3 = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:UITableViewStylePlain];
    self.tableview3.delegate = self;
    self.tableview3.dataSource = self;
    [self.allViews addObject:self.tableview3];

    self.yellowView = [[UIView alloc] initWithFrame:CGRectZero];
    self.yellowView.backgroundColor = [UIColor yellowColor];
    [self.allViews addObject:self.yellowView];
    
    self.purpleView = [[UIView alloc] initWithFrame:CGRectZero];
    self.purpleView.backgroundColor = [UIColor purpleColor];
    
    GVDataSource *dataSource = [GVDataSource new];
    dataSource.numberOfViewsCallBlock = ^() {
        return [self.allViews count];
    };
    
    [self.allAttributedStrings addObjectsFromArray:@[@"#1 TableView", @"Red View", @"#2 TableView", @"Green View", @"#3 TableView", @"Yellow View"]];
    
    dataSource.containedViewAtIndexCallblock = ^(NSUInteger index) {
        
        UIView *view = self.allViews[index];
        NSString *string = self.allAttributedStrings[index];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string];
        GVContainer *container = [[GVContainer alloc] initWithHeaderText:attributedString
                                                    linkedView:view];
        return container;
    };
    
    dataSource.headerHeightCallblock = ^() {
        return 60.f;
    };
    
    self.animatedPaging = [[GVAnimatedPaging alloc] initWithFrame:CGRectZero andDataSource:dataSource];
    [self.view addSubview:self.animatedPaging];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.animatedPaging.frame = self.view.bounds;
    CGFloat headerHeight = 60.f;
//    self.tableview1.frame = CGRectMake(0.0,
//                                       0.0,
//                                       CGRectGetWidth(self.view.bounds),
//                                       CGRectGetHeight(self.view.bounds) - headerHeight);
//    self.tableview2.frame = CGRectMake(0.f,
//                                       0.0,
//                                       CGRectGetWidth(self.view.bounds),
//                                       CGRectGetHeight(self.view.bounds) - headerHeight);
//    self.tableview3.frame = CGRectMake(0.f,
//                                       0.0,
//                                       CGRectGetWidth(self.view.bounds),
//                                       CGRectGetHeight(self.view.bounds) - headerHeight);
//    self.redView.frame = CGRectMake(0.f,
//                                    0.0,
//                                    CGRectGetWidth(self.view.bounds),
//                                    CGRectGetHeight(self.view.bounds) - headerHeight);
//    
//    self.greenView.frame = CGRectMake(0.f,
//                                    0.0,
//                                    CGRectGetWidth(self.animatedPaging.bounds),
//                                    CGRectGetHeight(self.view.bounds) - headerHeight);
//    self.yellowView.frame = CGRectMake(0.f,
//                                    0.0,
//                                    CGRectGetWidth(self.view.bounds),
//                                    CGRectGetHeight(self.view.bounds) - headerHeight);
//    
//    self.purpleView.frame = CGRectMake(0.f,
//                                       0.0,
//                                       CGRectGetWidth(self.view.bounds),
//                                       CGRectGetHeight(self.view.bounds) - headerHeight);
    
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
    
    cell.textLabel.text = @"Gabriel Vermesan";
    return cell;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.allViews addObject:self.purpleView];
//    [self.allAttributedStrings addObject:@"New view"];
//    [self.animatedPaging reloadData];
//}
@end
