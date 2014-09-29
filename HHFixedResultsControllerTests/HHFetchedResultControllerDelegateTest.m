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
                     [@{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""} mutableCopy],
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

/*
 On add and remove operations, only the added/removed object is reported.
 It’s assumed that all objects that come after the affected object are also moved, but these moves are not reported.
 */
- (void) testDidChangeObjectWithNSFetchedResultsChangeInsert {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeInsert) newIndexPath:OCMOCK_ANY];
    
    [self.frc addObject:@{@"type":@"1type", @"title":@"title title ", @"detail":@"test value9 and value", @"type2":@""}];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}

/*
 On add and remove operations, only the added/removed object is reported.
 It’s assumed that all objects that come after the affected object are also moved, but these moves are not reported.
 */
- (void) testDidChangeObjectWithNSFetchedResultsChangeDelete {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [self.frc setObjects:self.objects];
    [self.frc performFetch:nil];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeDelete) newIndexPath:OCMOCK_ANY];

    NSArray *changedObjects = @[
                                @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                @{@"type":@"1types",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                ];
    
    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


/*
 A move is reported when the changed attribute on the object is one of the sort descriptors used in the fetch request.
 An update of the object is assumed in this case, but no separate update message is sent to the delegate.
 */
- (void) testDidChangeObjectWithNSFetchedResultsChangeMove {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    
    [self.frc setObjects:self.objects];
    [self.frc performFetch:nil];
    
    [[(OCMockObject *)self.frc.delegate reject] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:NSFetchedResultsChangeInsert newIndexPath:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate reject] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:NSFetchedResultsChangeDelete newIndexPath:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate reject] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:NSFetchedResultsChangeUpdate newIndexPath:OCMOCK_ANY];

    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeMove) newIndexPath:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeMove) newIndexPath:OCMOCK_ANY];

    [self.objects[0] setObject:@"test value" forKey:@"detail"];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


#pragma mark - sections

- (void) testDidChangeSectionWithNSFetchedResultsChangeInsert {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[[(OCMockObject *)self.frc.delegate stub] ignoringNonObjectArgs] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:0 newIndexPath:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:2 forChangeType:(NSFetchedResultsChangeDelete)];

    [self.frc setObjects:self.objects];
    [self.frc performFetch:nil];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:2 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [self.frc addObject:@{@"type":@"3type", @"title":@"title third", @"detail":@"test value3", @"type2":@""}];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}

- (void) testDidChangeSectionWithNSFetchedResultsChangeDelete {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:2 forChangeType:(NSFetchedResultsChangeDelete)];
    
    NSArray *changedObjects = @[
                                @{@"type":@"1type", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                                @{@"type":@"2type", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                                @{@"type":@"1type", @"title":@"title", @"detail":@"test value0", @"type2":@""},
                                ];

    [self.frc setObjects:changedObjects];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
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
    [[[(OCMockObject *)self.frc.delegate stub] ignoringNonObjectArgs] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:0 newIndexPath:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];

    [self.frc addObject:@{@"type":@"1type", @"title":@"title five", @"detail":@"test value5", @"type2":@""}];
    [self.frc performFetch:nil];
    [(OCMockObject *)self.frc.delegate verify];
}


- (void) testWillAndDidChangeContentAndDidChangeContentWhenAnObjectAdded {
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[[(OCMockObject *)self.frc.delegate stub] ignoringNonObjectArgs] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:0 newIndexPath:OCMOCK_ANY];
    
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
    [[[(OCMockObject *)self.frc.delegate stub] ignoringNonObjectArgs] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:0 newIndexPath:OCMOCK_ANY];
    [[[(OCMockObject *)self.frc.delegate stub] ignoringNonObjectArgs] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeDelete)];

    
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
    [[[(OCMockObject *)self.frc.delegate stub] ignoringNonObjectArgs] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:0 newIndexPath:OCMOCK_ANY];
    
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeInsert)];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:1 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeDelete)];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:1 forChangeType:(NSFetchedResultsChangeDelete)];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:2 forChangeType:(NSFetchedResultsChangeDelete)];

    
    
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




#pragma mark - KVO

- (void) testWillAndDidChangeContentWithoutPerfomPatch {
    [[(OCMockObject *)self.frc.delegate expect] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:OCMOCK_ANY atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeUpdate) newIndexPath:OCMOCK_ANY];
    
    self.objects[0][@"detail"] = @"value1 test";
    [(HHFixedResultsController *)self.frc notifiyChangeObject:self.objects[0] key:@"detail" oldValue:@"test value1" newValue:@"value1 test"];
    [(OCMockObject *)self.frc.delegate verify];
}


/*
 An update is reported when an object’s state changes, but the changed attributes aren’t part of the sort keys.
 */
- (void) testDidChangeObjectWithNSFetchedResultsChangeUpdate {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [self.objects[0][@"detail"] isEqualToString:@"value1 test"];
    }] atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeUpdate) newIndexPath:OCMOCK_ANY];
    
    self.objects[0][@"detail"] = @"value1 test";
    [(HHFixedResultsController *)self.frc notifiyChangeObject:self.objects[0] key:@"detail" oldValue:@"test value1" newValue:@"value1 test"];
    [(OCMockObject *)self.frc.delegate verify];
}

- (void) testDidNotChangeObjectWithNSFetchedResultsChangeUpdate {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeInsert)];
    
    [[(OCMockObject *)self.frc.delegate stub] controller:(NSFetchedResultsController *)self.frc didChangeObject:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [self.objects[0][@"detail"] isEqualToString:@"test value1"];
    }] atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeUpdate) newIndexPath:OCMOCK_ANY];
    
    self.objects[0][@"detail"] = @"value1 test";
    [(HHFixedResultsController *)self.frc notifiyChangeObject:self.objects[0] key:@"detail" oldValue:@"test value1" newValue:@"test value1"];
    [(OCMockObject *)self.frc.delegate verify];
}

- (void) _testDidChangeObjectWithChangingSectionKeyValue {
    [[(OCMockObject *)self.frc.delegate stub] controllerWillChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate stub] controllerDidChangeContent:(NSFetchedResultsController *)self.frc];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc sectionIndexTitleForSectionName:OCMOCK_ANY];
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeSection:[OCMArg isNotNil] atIndex:0 forChangeType:(NSFetchedResultsChangeMove)];
    
    [[(OCMockObject *)self.frc.delegate expect] controller:(NSFetchedResultsController *)self.frc didChangeObject:[OCMArg checkWithBlock:^BOOL(id obj) {
        return [self.objects[0][@"detail"] isEqualToString:@"value1 test"];
    }] atIndexPath:OCMOCK_ANY forChangeType:(NSFetchedResultsChangeUpdate) newIndexPath:OCMOCK_ANY];
    
    self.objects[0][@"detail"] = @"value1 test";
    [(HHFixedResultsController *)self.frc notifiyChangeObject:self.objects[0] key:@"type" oldValue:@"1type" newValue:@"3type"];
    [(OCMockObject *)self.frc.delegate verify];
}

@end
