//
//  HHFixedResultsController.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import "HHFixedResultsController.h"
#import <CoreData/CoreData.h>


@interface HHSectionInfo : NSObject  <NSFetchedResultsSectionInfo>
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *indexTitle;
@property (nonatomic, readonly) NSUInteger numberOfObjects;
@property (nonatomic) NSMutableArray *objects;
@end

@implementation HHSectionInfo

- (id)init
{
    self = [super init];
    if (self) {
        _objects = [NSMutableArray array];
    }
    return self;
}


- (NSUInteger)numberOfObjects
{
    return [self.objects count];
}


- (NSUInteger)hash
{
    return [_name hash];
}

- (BOOL)isEqualToSectionInfo:(HHSectionInfo *)object
{
    return [_name isEqualToString:object.name];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    return [self isEqualToSectionInfo:object];
}

@end


@interface HHFixedResultsController ()

#pragma mark - private
@property (nonatomic) NSMutableArray *objects_;
@property (nonatomic) NSArray *indexTitles;
@property (nonatomic) NSDictionary *indexesForSectionName;

#pragma mark - public
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSArray *fetchedObjects;
@property (nonatomic) NSString *sectionNameKeyPath;
@property (nonatomic) NSString *cacheName;
@property (nonatomic) NSArray *sections;

#pragma mark - unused
@property (nonatomic) NSManagedObjectContext *managedObjectContext_;
@property (nonatomic, weak) id<NSObject, NSFetchedResultsControllerDelegate> delegate_;
@property (nonatomic) NSArray *sectionIndexTitles_;
@end


@implementation HHFixedResultsController (Private)


@end


@implementation HHFixedResultsController (NSFetchedResultsController)
@dynamic fetchRequest, managedObjectContext, sectionNameKeyPath, cacheName, delegate, fetchedObjects, sectionIndexTitles, sections;

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name
{
    self = [self initWithFetchRequest:fetchRequest objects:nil sectionNameKeyPath:sectionNameKeyPath cacheName:name];
    if (self)
    {
        self.managedObjectContext_ = context;
    }
    return self;
}

- (BOOL)performFetch:(NSError **)error
{
    NSArray *sFetchedObjects = [[self.objects filteredArrayUsingPredicate:self.fetchRequest.predicate] sortedArrayUsingDescriptors:self.fetchRequest.sortDescriptors];
    self.fetchedObjects = sFetchedObjects;
    
    NSMutableDictionary *indexesForSectionName = [NSMutableDictionary dictionary];
    NSMutableDictionary *sectionsByName = [NSMutableDictionary dictionary];
    NSMutableOrderedSet *sections = [NSMutableOrderedSet orderedSet];
    for (id object in self.fetchedObjects) {
        id sectionName =  object[self.sectionNameKeyPath?:@""];
        HHSectionInfo *sectionInfo = sectionsByName[sectionName?:@""];
        if (!sectionInfo)
        {
            sectionInfo = [[HHSectionInfo alloc] init];
            sectionInfo.name = [sectionName description];
            sectionInfo.indexTitle = [self sectionIndexTitleForSectionName:sectionInfo.name] ?: sectionInfo.name;
            [sections addObject:sectionInfo];
            sectionsByName[sectionInfo.name?:@""] = sectionInfo;
            indexesForSectionName[sectionInfo.indexTitle?:@""] = indexesForSectionName[sectionInfo.indexTitle?:@""] ?: @([sections count] - 1 );
        }
        [sectionInfo.objects addObject:object];
    }
    self.sections = [[sections filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"objects.@count > 0"]] array];
    self.indexTitles = [[NSOrderedSet orderedSetWithArray:[self.sections valueForKey:@"indexTitle"]] array];
    self.indexesForSectionName = [indexesForSectionName copy];
    
    return YES;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return self.managedObjectContext_;
}


- (id<NSFetchedResultsControllerDelegate>)delegate
{
    return self.delegate_;
}

- (void)setDelegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    self.delegate_ = (id<NSObject, NSFetchedResultsControllerDelegate>)delegate;
}

+ (void)deleteCacheWithName:(NSString *)name
{
    //TODO: not implemented
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        HHSectionInfo *sectionInfo = [self.sections objectAtIndex:indexPath.section];
        return [sectionInfo.objects objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        if ([exception.name isEqualToString:@"NSRangeException"])
        {
            return nil;
        }
        else
        {
            @throw exception;
        }
    }
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    for (NSUInteger idx = 0; idx < [self.sections count]; idx++)
    {
        HHSectionInfo *sectionInfo = [self.sections objectAtIndex:idx];
        NSUInteger index = [sectionInfo.objects indexOfObject:object];
        if (index != NSNotFound)
        {
            return [NSIndexPath indexPathForRow:index inSection:idx];
        }
    }
    return nil;
}

- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName
{
    if ([self.delegate_ respondsToSelector:@selector(controller:sectionIndexTitleForSectionName:)]) {
        return [self.delegate_ controller:(NSFetchedResultsController *)self sectionIndexTitleForSectionName:sectionName];
    }
    return sectionName;
}

- (NSArray *)sectionIndexTitles
{
    return self.indexTitles;
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex
{
    return [self.indexesForSectionName[title] integerValue];
}

@end


@interface HHFixedResultsController ()
@end


@implementation HHFixedResultsController
- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest objects:(NSArray *)kvcObjects sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name
{
    self = [super init];
    if (self) {
        _fetchRequest = fetchRequest;
        _objects = kvcObjects;
        _sectionNameKeyPath = sectionNameKeyPath;
        _cacheName = name;
    }
    return self;
}

- (void)addObject:(id)object
{
    
}

- (void)addObjectFromArray:(NSArray *)objects
{
    
}
@end

