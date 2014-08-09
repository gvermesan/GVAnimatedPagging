//
//  GVMainViewController.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVMainViewController.h"
#import "GVAnimattedPagging.h"

@interface GVMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GVAnimattedPagging *animattedPagging;
@property (nonatomic, strong) UITableView *tableview1;
@property (nonatomic, strong) UITableView *tableview2;
@property (nonatomic, strong) UITableView *tableview3;

@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation GVMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Animatted Pagging";
    self.mutableArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.animattedPagging];
    
    self.tableview1 = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    
    [self.mutableArray addObject:self.tableview1];
    self.tableview2 = [[UITableView alloc] initWithFrame:CGRectZero
                                                                  style:UITableViewStylePlain];

    self.tableview2.delegate = self;
    self.tableview2.dataSource = self;
    [self.mutableArray addObject:self.tableview2];
    
    self.tableview3 = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:UITableViewStylePlain];
    
    self.tableview3.delegate = self;
    self.tableview3.dataSource = self;
    [self.mutableArray addObject:self.tableview3];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.animattedPagging.frame = self.view.bounds;
    self.tableview1.frame = CGRectMake(0.0,
                                       0.0,
                                       CGRectGetWidth(self.animattedPagging.bounds),
                                       460);
    self.tableview2.frame = CGRectMake(0.f,
                                       0.0,
                                       CGRectGetWidth(self.animattedPagging.bounds),
                                       460);
    self.tableview3.frame = CGRectMake(0.f,
                                       0.0,
                                       CGRectGetWidth(self.animattedPagging.bounds),
                                       460);
    self.animattedPagging.views = self.mutableArray;
    
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

- (GVAnimattedPagging *)animattedPagging {
    if (!_animattedPagging) {
        NSArray *names = @[@"Endava", @"Gabriel", @"Vermesan"];
        _animattedPagging = [[GVAnimattedPagging alloc] initWithProportion:0.15 andHeaderNames:names];
        _animattedPagging.backgroundColor = [UIColor clearColor];
    }
    return _animattedPagging;
}

@end
