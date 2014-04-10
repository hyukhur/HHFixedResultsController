//
//  HHFetchedResultControllerDelegateTest.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 4. 1..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HHFixedResultsController.h"
#import <CoreData/CoreData.h>


@interface HHFetchedResultControllerDelegateTest : XCTestCase
@property (nonatomic, strong)HHFixedResultsController *frc;
@property (nonatomic, strong)NSArray *objects;
@end

@implementation HHFetchedResultControllerDelegateTest

- (void)setUp
{
    [super setUp];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:nil];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    self.objects = @[
                     @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                     @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                     @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                     @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                     @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                     ];
    
    self.frc = [[HHFixedResultsController alloc]
                initWithFetchRequest:request
                objects:self.objects
                sectionNameKeyPath:@"type"
                cacheName:nil];
    [self.frc performFetch:nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeInsert {
    
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeDelete {
    
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeMove {
    
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeUpdate {
    
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void) testDidChangeSectionWithNSFetchedResultsChangeInsert {
    
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void) testDidChangeSectionWithNSFetchedResultsChangeDelete {

}


//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void) testWillChangeContent {
    
}

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
- (void) testDidChangeContent {
    
}

//- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void) testSectionIndexTitleForSectionName {
    
}

@end
