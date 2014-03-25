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
    return [sectionName stringByAppendingString:@"_titile"];
}

- (void)setUp
{
    [super setUp];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:nil];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"detail" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title != %@", @"title"];
    
    self.objects = @[
                     @{@"type":@"type1", @"title":@"title one", @"detail":@"test value1", @"type2":@""},
                     @{@"type":@"type2", @"title":@"title two", @"detail":@"test value2", @"type2":@""},
                     @{@"type":@"type1", @"title":@"title zero", @"detail":@"test value0", @"type2":@""},
                     @{@"type":@"type1", @"title":@"title", @"detail":@"test value0", @"type2":@""},
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
    
    XCTAssertEqual((NSUInteger)3, [[frc fetchedObjects] count]);
    XCTAssertEqual((NSUInteger)2, [[frc sections] count]);
    XCTAssertEqual((NSUInteger)1, [[[[frc sections] lastObject] objects] count]);
    XCTAssertNotNil([[[frc sections] lastObject] name]);

}


- (void) testFetchAllObjects {
    NSArray *allObject = [self.frc fetchedObjects];
    XCTAssertEqual((NSUInteger)3, [allObject count]);
    XCTAssertEqual(@"test value2", [[allObject lastObject] objectForKey:@"detail"]);
}


- (void) testSections {
    XCTAssertNotNil([self.frc sections]);
    XCTAssertEqual((NSUInteger)2, [[self.frc sections] count]);
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] firstObject];
    XCTAssertEqualObjects(@"type1", [sectionInfo name]);
    XCTAssertEqualObjects(@"type2", [[[self.frc sections] lastObject] name]);
    XCTAssertEqual((NSUInteger)2, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)1, [[[[self.frc sections] lastObject] objects] count]);
}


- (void) testObjectAtIndexPath {
    id model = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertNotNil(model);
    
    XCTAssertEqualObjects(@"title zero", [model valueForKey:@"title"]);
    XCTAssertEqualObjects(@"test value0", [model valueForKey:@"detail"]);
    XCTAssertEqualObjects(@"type1", [model valueForKey:@"type"]);
}

- (void) testIndexPathForObject {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    id lastObject = [self.frc objectAtIndexPath:indexPath];
    NSIndexPath *expectedIndexPath = [self.frc indexPathForObject:lastObject];
    XCTAssertNotNil(lastObject);
    XCTAssertNotNil(expectedIndexPath);
    XCTAssertNotEqual(indexPath, expectedIndexPath);
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
    XCTAssertEqual((NSUInteger)3, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)3, [[frc fetchedObjects] count]);
    
    frc = [[HHFixedResultsController alloc]
           initWithFetchRequest:request
           objects:self.objects
           sectionNameKeyPath:@"type3"
           cacheName:nil];
    [frc performFetch:nil];
    XCTAssertEqual((NSUInteger)1, [[frc sections] count]);
    XCTAssertNil([[[frc sections] firstObject] name]);
    XCTAssertEqual((NSUInteger)3, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)3, [[frc fetchedObjects] count]);
    
    frc = [[HHFixedResultsController alloc]
           initWithFetchRequest:request
           objects:self.objects
           sectionNameKeyPath:nil
           cacheName:nil];
    [frc performFetch:nil];
    XCTAssertEqual((NSUInteger)1, [[frc sections] count]);
    XCTAssertNil([[[frc sections] firstObject] name]);
    XCTAssertEqual((NSUInteger)3, [[sectionInfo objects] count]);
    XCTAssertEqual((NSUInteger)3, [[frc fetchedObjects] count]);
}

- (void) testSectionIndexTitles {
    NSArray * titles = [self.frc sectionIndexTitles];
    XCTAssertEqualObjects(@"type1", [titles firstObject]);
    XCTAssertEqualObjects(@"type2", [titles lastObject]);
}

- (void) testSectionForSectionIndexTitleAtIndex {
    
}

- (void) testSectionIndexTitleForSectionName {
    NSString *indexTitle = [self.frc sectionIndexTitleForSectionName:@"type1"];
    XCTAssertEqualObjects(@"type1", indexTitle);
    
    [self.frc setDelegate:self];
    indexTitle = [self.frc sectionIndexTitleForSectionName:@"type1"];
    XCTAssertEqualObjects(@"type1_titile", indexTitle);
    [self.frc setDelegate:nil];
}


- (void) testCacheName {
    
}

- (void) testDeleteCacheWithName {
    
}

- (void) testSetObjects {
    
}


- (void) testAddObject {
    
}

- (void) testAddObjects {
    
}

- (void) testDelegate {
    
}
@end
