//
//  HHFixedResultsControllerTests.m
//  HHFixedResultsControllerTests
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HHFixedResultsController.h"
#import <CoreData/CoreData.h>

@interface HHFixedResultsControllerTests : XCTestCase
@property (nonatomic, strong)HHFixedResultsController *frc;
@end

@implementation HHFixedResultsControllerTests

- (void)setUp
{
    [super setUp];
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:nil];
    requst.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES]];
    requst.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    self.frc = [[HHFixedResultsController alloc]
                initWithFetchRequest:requst
                objects:@[
                          @{@"type":@"type1", @"title":@"title one", @"detail":@"test value1"},
                          @{@"type":@"type2", @"title":@"title two", @"detail":@"test value2"},
                          @{@"type":@"type1", @"title":@"title three", @"detail":@"test value0"},
                          @{@"type":@"type1", @"title":@"title", @"detail":@"test value0"},
                          ]
                sectionNameKeyPath:@"type"
                cacheName:nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFetch
{
    id model = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual(@"title one", [model valueForKey:@"title"]);
    XCTAssertEqual(@"test value1", [model valueForKey:@"detail"]);
    XCTAssertEqual(@"type1", [model valueForKey:@"type"]);
}


- (void) testSection {
    XCTAssertEqual(2, [[self.frc sections] count]);
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] firstObject];
    XCTAssertEqual(@"type1", [sectionInfo name]);
    XCTAssertEqual(@"type2", [[self.frc sections] lastObject]);
}

@end
