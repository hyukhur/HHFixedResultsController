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

@interface HHViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HHFixedResultsController *frc;
@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:nil];
    requst.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
    requst.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    self.frc = [[HHFixedResultsController alloc] initWithFetchRequest:requst
                                                              objects:@[
                                                                        @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                                                        @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                                                        @{@"type":@"1typ",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                                                        @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                                                        @{@"type":@"1typ",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                                                        @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                                                        @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                                                        @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                                                        @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                                                        @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                                                        @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                                                        @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                                                        @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                                                        @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},

                                                                        ]
                                                   sectionNameKeyPath:@"type"
                                                            cacheName:nil];
    self.frc.delegate = self;
    [self.frc performFetch:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.frc.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [[self.frc.sections objectAtIndex:section] name];
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


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.frc sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.frc sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return [NSString stringWithFormat: @"%C", [sectionName characterAtIndex:0]];
}

@end
