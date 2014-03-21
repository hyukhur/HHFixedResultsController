//
//  HHViewController.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import "HHViewController.h"
#import "HHFixedResultsController.h"
#import <CoreData/CoreData.h>

@interface HHViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HHFixedResultsController *frc;
@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HHViewController"];
    
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:nil];
    requst.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES]];
    requst.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    self.frc = [[HHFixedResultsController alloc] initWithFetchRequest:requst objects:@[
  @{@"type":@"type1", @"title":@"title one", @"detail":@"test value1"},
  @{@"type":@"type2", @"title":@"title two", @"detail":@"test value2"},
  @{@"type":@"type1", @"title":@"title three", @"detail":@"test value0"},
  @{@"type":@"type1", @"title":@"title", @"detail":@"test value0"},
  ] sectionNameKeyPath:@"type" cacheName:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.frc.sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHViewController" forIndexPath:indexPath];
    id model = [self.frc objectAtIndexPath:indexPath];
    [cell.textLabel setText:[model valueForKey:@"title"]];
    [cell.detailTextLabel setText:[model valueForKey:@"detail"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.frc.sections objectAtIndex:section] numberOfObjects];
}

@end
