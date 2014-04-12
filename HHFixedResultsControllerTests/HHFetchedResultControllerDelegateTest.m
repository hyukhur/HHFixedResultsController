//
//  HHFetchedResultControllerDelegateTest.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 4. 1..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
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
    id<NSFetchedResultsControllerDelegate> delegate = [OCMockObject mockForProtocol:@protocol(NSFetchedResultsControllerDelegate)];
    self.frc.delegate = delegate;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}



#pragma mark - each object change

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeInsert {
    XCTFail(@"Not Yet Implemented");
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeDelete {
    XCTFail(@"Not Yet Implemented");
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeMove {
    XCTFail(@"Not Yet Implemented");
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void) testDidChangeObjectWithNSFetchedResultsChangeUpdate {
    XCTFail(@"Not Yet Implemented");
}


#pragma mark - sections

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void) testDidChangeSectionWithNSFetchedResultsChangeInsert {
    XCTFail(@"Not Yet Implemented");
}

//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void) testDidChangeSectionWithNSFetchedResultsChangeDelete {
    XCTFail(@"Not Yet Implemented");
}


#pragma mark - something chagned

- (void) testWillAndDidChangeContentAndDidChangeContentWhenObjectRemoved {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    NSArray *changedObjects = @[
                @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                ];
    
    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}

- (void) testWillAndDidChangeContentAndDidChangeContentWhenObjectAdded {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    NSArray *changedObjects = @[
                                @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title five", @"detail":@"test value5", @"type2":@""},
                                ];
    
    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


- (void) testWillAndDidChangeContentAndDidChangeContentWhenAnObjectAdded {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];

    [self.frc addObject:@{@"type":@"1type", @"title":@"title five", @"detail":@"test value5", @"type2":@""}];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}

- (void) testWillAndDidChangeContentAndDidChangeContentWhenObjectMoved {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    NSArray *changedObjects = @[
                                @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                ];
    
    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


- (void) testWillAndDidChangeContentAndDidChangeContentWhenObjectChanged {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    NSArray *changedObjects = @[
                                @{@"type":@"1type", @"title":@"title 1", @"detail":@"test value one", @"type2":@""},
                                @{@"type":@"2type", @"title":@"title 2", @"detail":@"test value two", @"type2":@""},
                                @{@"type":@"1types",@"title":@"title 4", @"detail":@"test value four", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title 0", @"detail":@"test value zero", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                ];
    
    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}

- (void) testWillAndDidChangeContentAndDidChangeContentWhenSectionChanged {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    NSArray *changedObjects = @[
                                @{@"type":@"type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                @{@"type":@"type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                @{@"type":@"types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                @{@"type":@"type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                @{@"type":@"type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                ];

    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


- (void) testWillNotAndDidNotChangeContentAndDidChangeContent {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
    
    [[(OCMockObject *)self.frc.delegate reject] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate reject] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];

    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


#pragma mark - KVO

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void) testWillAndDidChangeContentWithoutPerfomPatch {
    XCTFail(@"Not Yet Implemented");
}


//- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
- (void) testSectionIndexTitleForSectionName {
    [self.frc setObjects:nil];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:@"1type"];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:@"2type"];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:@"1types"];
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    [self.frc setObjects:self.objects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


- (void) testSectionIndexTitleForSectionNameWithoutChanged {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];

    [self.frc setObjects:self.objects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];

    [[(OCMockObject *)self.frc.delegate reject] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate reject] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate reject] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];

    [self.frc setObjects:self.objects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}

@end
