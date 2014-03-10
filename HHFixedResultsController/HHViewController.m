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
    self.frc = [[HHFixedResultsController alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHViewController" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.frc.sections objectAtIndex:section] count];
}

@end
