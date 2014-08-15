//
//  GVMainViewController.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVMainViewController.h"
#import "GVAnimatedPaging.h"

#define DEVICE_IS_IPAD ( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

@interface GVMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GVAnimatedPaging *animatedPaging;
@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;
@property (nonatomic, strong) UITableView *tableview3;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *yellowView;

@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation GVMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Animated Paging";
    self.mutableArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.animatedPaging];
    
    self.tableview1 = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    [self.mutableArray addObject:self.tableview1];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redView.backgroundColor = [UIColor redColor];
    [self.mutableArray addObject:self.redView];
    
    self.tableview2 = [[UITableView alloc] initWithFrame:CGRectZero
                                                                  style:UITableViewStylePlain];

    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    [self.mutableArray addObject:self.tableview2];
    
    self.greenView = [[UIView alloc] initWithFrame:CGRectZero];
    self.greenView.backgroundColor = [UIColor greenColor];
    [self.mutableArray addObject:self.greenView];
    
    self.tableview3 = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:UITableViewStylePlain];
    self.tableview3.delegate = self;
    self.tableview3.dataSource = self;
    [self.mutableArray addObject:self.tableview3];

    self.yellowView = [[UIView alloc] initWithFrame:CGRectZero];
    self.yellowView.backgroundColor = [UIColor yellowColor];
    [self.mutableArray addObject:self.yellowView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.animatedPaging.frame = self.view.bounds;
    CGFloat proportion = DEVICE_IS_IPAD ? 0.1f : 0.15f;
    self.tableview1.frame = CGRectMake(0.0,
                                       0.0,
                                       CGRectGetWidth(self.animatedPaging.bounds),
                                       CGRectGetHeight(self.view.bounds) * (1.f - proportion));
    self.tableview2.frame = CGRectMake(0.f,
                                       0.0,
                                       CGRectGetWidth(self.animatedPaging.bounds),
                                       CGRectGetHeight(self.view.bounds) * (1.f - proportion));
    self.tableview3.frame = CGRectMake(0.f,
                                       0.0,
                                       CGRectGetWidth(self.animatedPaging.bounds),
                                       CGRectGetHeight(self.view.bounds) * (1.f - proportion));
    self.redView.frame = CGRectMake(0.f,
                                    0.0,
                                    CGRectGetWidth(self.animatedPaging.bounds),
                                    CGRectGetHeight(self.view.bounds) * (1.f - proportion));
    
    self.greenView.frame = CGRectMake(0.f,
                                    0.0,
                                    CGRectGetWidth(self.animatedPaging.bounds),
                                    CGRectGetHeight(self.view.bounds) * (1.f - proportion));
    self.yellowView.frame = CGRectMake(0.f,
                                    0.0,
                                    CGRectGetWidth(self.animatedPaging.bounds),
                                    CGRectGetHeight(self.view.bounds) * (1.f - proportion));
    
    self.animatedPaging.views = self.mutableArray;
    
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
#pragma mark - Property

- (GVAnimatedPaging *)animatedPaging {
    if (!_animatedPaging) {
        NSArray *names = @[@"#1 TableView",
                           @"Red View",
                           @"#2 TableView",
                           @"Green View",
                           @"#3 TableView",
                           @"Yellow View"];
        
        CGFloat proportion = DEVICE_IS_IPAD ? 0.1f : 0.15f;
        _animatedPaging = [[GVAnimatedPaging alloc] initWithProportion:proportion andHeaderNames:names];
        _animatedPaging.backgroundColor = [UIColor clearColor];
    }
    return _animatedPaging;
}

@end
