//
//  HHFixedResultsController.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import "HHFixedResultsController.h"
#import <CoreData/CoreData.h>


typedef BOOL(^HHObjectsChangingSpecBlock)(NSArray *oldFetchedObjects, NSArray *newFetchedObjects);


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


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ ( name : %@ \t indexTitle: %@ )", [super description], self.name, self.indexTitle];
}
@end


@interface HHFixedResultsController ()

#pragma mark - private
@property (nonatomic) NSArray *indexTitles;
@property (nonatomic) NSDictionary *indexesForSectionName;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSOrderedSet *sectionSet;
@property (nonatomic, weak) id<NSObject, NSFetchedResultsControllerDelegate> delegate;
@property (nonatomic, weak) id<NSObject, NSFetchedResultsControllerDelegate> previousDelegate;


#pragma mark - public
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSArray *fetchedObjects;
@property (nonatomic) NSString *sectionNameKeyPath;
@property (nonatomic) NSString *cacheName;

@end


@implementation HHFixedResultsController (Private)


- (void)willChangeContent
{
    if ([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]) {
        [self.delegate performSelector:@selector(controllerWillChangeContent:) withObject:self];
    }
}


- (void)didChangeContent
{
    if ([self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]) {
        [self.delegate performSelector:@selector(controllerDidChangeContent:) withObject:self];
    }
}


- (void)didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if ([self.delegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)]) {
        [self.delegate controller:(NSFetchedResultsController *)self didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    }
}



- (NSArray *)fetchObjectsChangedSpecs
{
    return @[
             (HHObjectsChangingSpecBlock) ^(NSArray *oldFetchedObjects, NSArray *newFetchedObjects) {
                 return ([oldFetchedObjects count] != [newFetchedObjects count]);
             },
             (HHObjectsChangingSpecBlock) ^(NSArray *oldFetchedObjects, NSArray *newFetchedObjects) {
                 return ([oldFetchedObjects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                     return [newFetchedObjects indexOfObjectIdenticalTo:obj] != idx;
                 }] != NSNotFound);
             },
             ];
}


- (void)didChangeSection:(NSOrderedSet *)oldSet newSection:(NSOrderedSet *)newSet
{
    NSMutableOrderedSet *inserted = [newSet mutableCopy];
    [inserted minusOrderedSet:oldSet];
    [inserted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self didChangeSection:obj atIndex:[newSet indexOfObject:obj] forChangeType:(NSFetchedResultsChangeInsert)];
    }];
    
    NSMutableOrderedSet *deleted = [oldSet mutableCopy];
    [deleted minusOrderedSet:newSet];
    
    [deleted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self didChangeSection:obj atIndex:[oldSet indexOfObject:obj] forChangeType:(NSFetchedResultsChangeDelete)];
    }];
}

@end


@implementation HHFixedResultsController (NSFetchedResultsController)
//@dynamic fetchRequest, managedObjectContext, sectionNameKeyPath, cacheName, delegate, fetchedObjects, sectionIndexTitles, sections;

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name
{
    self = [self initWithFetchRequest:fetchRequest objects:nil sectionNameKeyPath:sectionNameKeyPath cacheName:name];
    if (self)
    {
        self.managedObjectContext = context;
    }
    return self;
}

/*
 if the fetch request doesn’t include a sort descriptor that uses the section name key path specified
 */
- (BOOL)performFetch:(NSError **)error
{
    NSArray *sFetchedObjects = [[self.objects filteredArrayUsingPredicate:self.fetchRequest.predicate] sortedArrayUsingDescriptors:self.fetchRequest.sortDescriptors];
    BOOL hasChanged = self.previousDelegate != self.delegate;
    hasChanged |= [[self fetchObjectsChangedSpecs] indexOfObjectPassingTest:^BOOL(HHObjectsChangingSpecBlock specBlock, NSUInteger idx, BOOL *stop) {
        return specBlock(sFetchedObjects, self.fetchedObjects);
    }] != NSNotFound;
    if (hasChanged) {
        [self willChangeContent];
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
        [sections filterUsingPredicate:[NSPredicate predicateWithFormat:@"objects.@count > 0"]];
        
        [self didChangeSection:self.sectionSet newSection:sections];
        
        self.sectionSet = sections;
        self.indexTitles = [[NSOrderedSet orderedSetWithArray:[self.sections valueForKey:@"indexTitle"]] array];
        self.indexesForSectionName = [indexesForSectionName copy];

        [self didChangeContent];
    }
    
    self.previousDelegate = self.delegate;
    return YES;
}


+ (void)deleteCacheWithName:(NSString *)name
{
    //TODO: not implemented
}


- (NSArray *)sections
{
    return [self.sectionSet array];
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
    if ([self.delegate respondsToSelector:@selector(controller:sectionIndexTitleForSectionName:)]) {
        return [self.delegate controller:(NSFetchedResultsController *)self sectionIndexTitleForSectionName:sectionName];
    }
    /*
     The default implementation returns the capitalized first letter of the section name.
     */
    return [sectionName length] > 0 ? [NSString stringWithFormat: @"%C", [[sectionName capitalizedString] characterAtIndex:0]] : sectionName;
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
    self.objects = [self.objects arrayByAddingObject:object];
}

- (void)addObjectFromArray:(NSArray *)objects
{
    self.objects = [self.objects arrayByAddingObjectsFromArray:objects];
}
@end

