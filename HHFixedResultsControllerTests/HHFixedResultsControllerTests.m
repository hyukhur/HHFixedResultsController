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

@interface HHFixedResultsControllerTests : XCTestCase <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong)HHFixedResultsController *frc;
@property (nonatomic, strong)NSArray *objects;
@end

@implementation HHFixedResultsControllerTests

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return sectionName;
}

- (void)setUp
{
    [super setUp];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:nil];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    self.objects = @[
                     @{@"type":@"atype", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                     @{@"type":@"btype", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                     @{@"type":@"atypes",@"title":@"title fouth", @"detail":@"test value4", @"type2":@""},
                     @{@"type":@"atype", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                     @{@"type":@"atype", @"title":@"title", @"detail":@"test value0", @"type2":@""},
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
    [super tearDown];
}

- (void)testFetch
{
    HHFixedResultsController *frc = [[HHFixedResultsController alloc]
                initWithFetchRequest:self.frc.fetchRequest
                objects:self.objects
                sectionNameKeyPath:@"type"
                cacheName:nil];

    XCTAssertEqual((NSUInteger)0, [[frc fetchedObjects] count]);
    XCTAssertEqual((NSUInteger)0, [[frc sections] count]);
    XCTAssertEqual((NSUInteger)0, [[[[frc sections] lastObject] objects] count]);
    XCTAssertNil([[[frc sections] lastObject] name]);
    [frc performFetch:nil];
    
    XCTAssertEqual((NSUInteger)4, [[frc fetchedObjects] count]);
    XCTAssertEqual((NSUInteger)3, [[frc sections] count]);
    XCTAssertEqual((NSUInteger)1, [[[[frc sections] lastObject] objects] count]);
    XCTAssertNotNil([[[frc sections] lastObject] name]);

}


- (void) testFetchAllObjects {
    NSArray *allObject = [self.frc fetchedObjects];
    XCTAssertEqual((NSUInteger)4, [allObject count]);
    XCTAssertEqual(@"test value4", [[allObject lastObject] objectForKey:@"detail"]);
}


- (void) testSections {
    XCTAssertNotNil([self.frc sections]);
    XCTAssertEqual((NSUInteger)3, [[self.frc sections] count]);
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] firstObject];
    XCTAssertEqualObjects(@"atype", [sectionInfo name]);
    XCTAssertEqualObjects(@"btype", [[[self.frc sections] objectAtIndex:1] name]);
    XCTAssertEqualObjects(@"atypes", [[[self.frc sections] lastObject] name]);
    XCTAssertEqual((NSUInteger)2, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)1, [[[[self.frc sections] lastObject] objects] count]);
}


- (void) testObjectAtIndexPath {
    id model = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(model);
    
    XCTAssertEqualObjects(@"title zero", [model valueForKey:@"title"]);
    XCTAssertEqualObjects(@"test value0", [model valueForKey:@"detail"]);
    XCTAssertEqualObjects(@"atype", [model valueForKey:@"type"]);
}

- (void) testIndexPathForObject {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    id lastObject = [self.frc objectAtIndexPath:indexPath];
    NSIndexPath *expectedIndexPath = [self.frc indexPathForObject:lastObject];
    XCTAssertNotNil(lastObject);
    XCTAssertNotNil(expectedIndexPath);
    XCTAssertEqual(indexPath, expectedIndexPath);
    XCTAssertEqual(indexPath.section, expectedIndexPath.section);
    XCTAssertEqual(indexPath.row, expectedIndexPath.row);
    
    
    expectedIndexPath = [self.frc indexPathForObject:[self.objects lastObject]];
    XCTAssertNil(expectedIndexPath);
    expectedIndexPath = [self.frc indexPathForObject:@{@"type":@"type1", @"title":@"title", @"detail":@"test value0"}];
    XCTAssertNil(expectedIndexPath);
    expectedIndexPath = [self.frc indexPathForObject:[[self.objects firstObject] copy]];
    XCTAssertNotNil(expectedIndexPath);
}

- (void) testSectionNameKeyPath {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:nil];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    HHFixedResultsController *frc = [[HHFixedResultsController alloc]
                initWithFetchRequest:request
                objects:self.objects
                sectionNameKeyPath:@"type2"
                cacheName:nil];
    [frc performFetch:nil];
    id<NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] firstObject];
    XCTAssertEqualObjects(@"", [sectionInfo name]);
    XCTAssertEqualObjects(@"", [[[frc sections] lastObject] name]);
    XCTAssertEqual((NSUInteger)4, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)4, [[frc fetchedObjects] count]);
    
    frc = [[HHFixedResultsController alloc]
           initWithFetchRequest:request
           objects:self.objects
           sectionNameKeyPath:@"type3"
           cacheName:nil];
    [frc performFetch:nil];
    XCTAssertEqual((NSUInteger)1, [[frc sections] count]);
    XCTAssertNil([[[frc sections] firstObject] name]);
    XCTAssertEqual((NSUInteger)4, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)4, [[frc fetchedObjects] count]);
    
    frc = [[HHFixedResultsController alloc]
           initWithFetchRequest:request
           objects:self.objects
           sectionNameKeyPath:nil
           cacheName:nil];
    [frc performFetch:nil];
    XCTAssertEqual((NSUInteger)1, [[frc sections] count]);
    XCTAssertNil([[[frc sections] firstObject] name]);
    XCTAssertEqual((NSUInteger)4, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)4, [[frc fetchedObjects] count]);
}

- (void) testSectionIndexTitles {
    self.frc.delegate = self;
    [self.frc performFetch:nil];
    NSArray *titles = [self.frc sectionIndexTitles];
    XCTAssertEqualObjects(@"atype", [titles firstObject]);
    XCTAssertEqualObjects(@"btype", [titles objectAtIndex:1]);
    XCTAssertEqualObjects(@"atypes", [titles lastObject]);
    
    self.frc.delegate = nil;
    [self.frc performFetch:nil];
    titles = [self.frc sectionIndexTitles];
    XCTAssertEqual((NSUInteger)2, [titles count]);
    XCTAssertEqualObjects(@"A", [titles firstObject]);
    XCTAssertEqualObjects(@"B", [titles lastObject]);
}

- (void) testSectionForSectionIndexTitleAtIndex {
    self.frc.delegate = self;
    [self.frc performFetch:nil];
    NSInteger index = [self.frc sectionForSectionIndexTitle:@"atype" atIndex:0];
    XCTAssertEqual(0, index);
    index = [self.frc sectionForSectionIndexTitle:@"btype" atIndex:1];
    XCTAssertEqual(1, index);
    index = [self.frc sectionForSectionIndexTitle:@"atypes" atIndex:2];
    XCTAssertEqual(2, index);
    
    [self.frc setDelegate:nil];
    [self.frc performFetch:nil];
    index = [self.frc sectionForSectionIndexTitle:@"A" atIndex:0];
    XCTAssertEqual(0, index);
    index = [self.frc sectionForSectionIndexTitle:@"B" atIndex:2];
    XCTAssertEqual(1, index);
    index = [self.frc sectionForSectionIndexTitle:@"A" atIndex:1];
    XCTAssertEqual(0, index);
    [self.frc setDelegate:nil];
}

- (void) testSectionIndexTitleForSectionName {
    [self.frc setDelegate:self];
    NSString *indexTitle = [self.frc sectionIndexTitleForSectionName:@"atype"];
    XCTAssertEqualObjects(@"atype", indexTitle);
    
    [self.frc setDelegate:nil];
    indexTitle = [self.frc sectionIndexTitleForSectionName:@"type"];
    XCTAssertEqualObjects(@"T", indexTitle);
}

- (void) testSetObjects {
    [self.frc setObjects:[self.objects arrayByAddingObjectsFromArray:self.objects]];
    
    [self testFetchAllObjects];
    [self testSections];
    [self testObjectAtIndexPath];
    [self testIndexPathForObject];
    [self testSectionIndexTitleForSectionName];
    
    [self.frc performFetch:nil];
    
    XCTAssertNotNil([self.frc sections]);
    XCTAssertEqual((NSUInteger)3, [[self.frc sections] count]);
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] firstObject];
    XCTAssertEqualObjects(@"atype", [sectionInfo name]);
    XCTAssertEqualObjects(@"btype", [[[self.frc sections] objectAtIndex:1] name]);
    XCTAssertEqualObjects(@"atypes", [[[self.frc sections] lastObject] name]);
    XCTAssertEqual((NSUInteger)4, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)2, [[[[self.frc sections] lastObject] objects] count]);
}


- (void) testAddObject {
    [self.frc addObject:[self.objects firstObject]];
    
    [self testFetchAllObjects];
    [self testSections];
    [self testObjectAtIndexPath];
    [self testIndexPathForObject];
    [self testSectionIndexTitleForSectionName];
    
    [self.frc performFetch:nil];
    
    XCTAssertNotNil([self.frc sections]);
    XCTAssertEqual((NSUInteger)3, [[self.frc sections] count]);
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] firstObject];
    XCTAssertEqualObjects(@"atype", [sectionInfo name]);
    XCTAssertEqualObjects(@"btype", [[[self.frc sections] objectAtIndex:1] name]);
    XCTAssertEqualObjects(@"atypes", [[[self.frc sections] lastObject] name]);
    XCTAssertEqual((NSUInteger)3, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)1, [[[[self.frc sections] lastObject] objects] count]);
}

- (void) testAddObjects {
    [self.frc addObjectFromArray:self.objects];
    
    [self testFetchAllObjects];
    [self testSections];
    [self testObjectAtIndexPath];
    [self testIndexPathForObject];
    [self testSectionIndexTitleForSectionName];
    
    [self.frc performFetch:nil];
    
    XCTAssertNotNil([self.frc sections]);
    XCTAssertEqual((NSUInteger)3, [[self.frc sections] count]);
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] firstObject];
    XCTAssertEqualObjects(@"atype", [sectionInfo name]);
    XCTAssertEqualObjects(@"btype", [[[self.frc sections] objectAtIndex:1] name]);
    XCTAssertEqualObjects(@"atypes", [[[self.frc sections] lastObject] name]);
    XCTAssertEqual((NSUInteger)4, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)2, [[[[self.frc sections] lastObject] objects] count]);
}


- (void) testCacheName {
    
}

- (void) testDeleteCacheWithName {
    
}


@end
