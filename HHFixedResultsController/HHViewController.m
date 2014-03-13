//
//  HHViewController.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import "HHViewController.h"
#import "HHFixedResultsController.h"

@interface HHViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) HHFixedResultsController *frc;
@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.frc = [[HHFixedResultsController alloc] initWithPredicate:[NSPredicate predicateWithValue:YES] objects:@[@[@{@"title":@"value"},@{@"title":@"value2"}]] sectionNameKeyPath:nil cacheName:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHViewController" forIndexPath:indexPath];
    id model = [self.frc objectAtIndexPath:indexPath];
    [cell.textLabel setText:[model valueForKey:@"title"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.frc.sections objectAtIndex:section] count];
}

@end
