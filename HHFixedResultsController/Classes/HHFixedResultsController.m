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
- (NSUInteger)numberOfObjects
{
    return [self.objects count];
}
@end


@interface HHFixedResultsController ()
@property (nonatomic) id objects;
@property (nonatomic) NSMutableArray *sections;

#pragma mark -
@property (nonatomic) NSFetchRequest *fetchRequest_;
@property (nonatomic) NSManagedObjectContext *managedObjectContext_;
@property (nonatomic) NSString *sectionNameKeyPath_;
@property (nonatomic) NSString *cacheName_;
@property (nonatomic, weak) id<NSObject, NSFetchedResultsControllerDelegate> delegate_;
@property (nonatomic) NSArray *fetchedObjects_;
@property (nonatomic) NSArray *sectionIndexTitles_;
@property (nonatomic) NSArray *sections_;
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
    self.objects = [self.objects sortedArrayUsingDescriptors:self.fetchRequest.sortDescriptors];

    for (id sectionName in [self.objects valueForKey:self.sectionNameKeyPath]) {
        HHSectionInfo *sectionInfo = [[HHSectionInfo alloc] init];
        sectionInfo.name = [sectionName description];
        if ([self.delegate_ respondsToSelector:@selector(controller:sectionIndexTitleForSectionName:)]) {
            sectionInfo.indexTitle = [self.delegate_ controller:(NSFetchedResultsController *)self sectionIndexTitleForSectionName:sectionInfo.name];
        }
//        [sectionInfo setName:[sectionName description]];
    }
    
    return YES;
}

- (NSFetchRequest *)fetchRequest
{
    return self.fetchRequest_;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return self.managedObjectContext_;
}

- (NSString *)sectionNameKeyPath
{
    return self.sectionNameKeyPath_;
}

- (NSString *)cacheName
{
    return self.cacheName_;
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

- (NSArray *)fetchedObjects
{
    return self.fetchedObjects_;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    return nil;
}

- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return nil;
}

- (NSArray *)sectionIndexTitles
{
    return self.sectionIndexTitles_;
}

- (NSArray *)sections
{
    return self.sections_;
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex
{
    return 0;
}

@end


@interface HHFixedResultsController ()
@property (nonatomic) NSMutableArray *sectionInfos;
@end


@implementation HHFixedResultsController
- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest objects:(id)kvcObjects sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name
{
    self = [super init];
    if (self) {
        _objects = kvcObjects;
        _fetchRequest_ = fetchRequest;
        _sectionNameKeyPath_ = sectionNameKeyPath;
        _cacheName_ = name;
        _sections = [NSMutableArray array];
        [self performFetch:nil];
    }
    return self;
}

- (void)addObject:(id)objects
{
    
}
@end

