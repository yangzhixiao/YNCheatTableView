//
//  ViewController.m
//  YNCheatTableView
//
//  Created by 杨智晓 on 16/5/16.
//  Copyright © 2016年 yangzhixiao. All rights reserved.
//

#import "ViewController.h"
#import "YNCheatTableView.h"
#import "MenuTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, YNCheatTableViewDelegate>
@property (weak, nonatomic) IBOutlet YNCheatTableView *tableView;
@property (assign, nonatomic) NSInteger columnIndex;
@property (strong, nonatomic) NSMutableDictionary *screenshotDict;
@property (strong, nonatomic) UITableViewCell *categoryMenuCell;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.columnIndex = 0;
    self.screenshotDict = [NSMutableDictionary dictionary];
    self.tableView.cheatDelegate = self;
    [self.tableView setupCheatView];
}

#pragma mark - YNCheatTableViewDelegate

- (NSInteger)columnCountForCheat {
    return 3;
}

- (CGFloat)YNCheatTableViewShouldCaptureViewAtPositonY {
    CGPoint point = [self.tableView convertPoint:self.categoryMenuCell.frame.origin toView:self.view];
    CGFloat offsetY = point.y + 34;
    NSLog(@"menu posY: %@", @(offsetY));
    return offsetY;
}

- (BOOL)YNCheatTableViewShouldScrollAtPoint:(CGPoint)panTouchPoint {
    CGPoint menuPosition = [self.tableView convertPoint:self.categoryMenuCell.frame.origin toView:self.view];
    return panTouchPoint.y > menuPosition.y + 50;
}

- (void)YNCheatTableViewDidScrollTo:(NSInteger)index {
    self.columnIndex = index;
    [self.tableView reloadData];
}

- (UIView *)loadingViewForTableViewAtIndex:(NSInteger)index {
    UILabel *loadingLabel = [[UILabel alloc]init];
    loadingLabel.bounds = CGRectMake(0, 0, 375, 50);
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Loading...";
    return loadingLabel;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return  60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *cellId = @"MenuTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.categoryMenuCell = cell;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"广告";
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        static NSString *cellId = @"cellId3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.columnIndex == 0) {
            cell.contentView.backgroundColor = [UIColor blueColor];
            cell.textLabel.text = @"0";
        }
        if (self.columnIndex == 1) {
            cell.contentView.backgroundColor = [UIColor greenColor];
            cell.textLabel.text = @"1";
        }
        if (self.columnIndex == 2) {
            cell.contentView.backgroundColor = [UIColor redColor];
            cell.textLabel.text = @"2";
        }
        return cell;
    }
    
    return nil;
}

- (IBAction)scrollTest:(id)sender {
    [self.tableView scrollToColumnAtIndex:arc4random() % 3];
//    [self.tableView scrollToColumnAtIndex:2];
}

- (IBAction)btnStop:(id)sender {
    self.tableView.debug = !self.tableView.debug;
}

@end
