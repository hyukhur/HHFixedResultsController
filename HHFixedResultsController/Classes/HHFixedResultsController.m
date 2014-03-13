//
//  HHFixedResultsController.m
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import "HHFixedResultsController.h"
#import <CoreData/NSFetchedResultsController.h>


@interface HHSectionInfo : NSObject  <NSFetchedResultsSectionInfo>
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *indexTitle;
@property (nonatomic) NSUInteger numberOfObjects;
@property (nonatomic) NSMutableArray *objects;
@end

@implementation HHSectionInfo

@end


@interface HHFixedResultsController ()
@property (nonatomic) NSFetchRequest *fetchRequest_;
@property (nonatomic) NSManagedObjectContext *managedObjectContext_;
@property (nonatomic) NSString *sectionNameKeyPath_;
@property (nonatomic) NSString *cacheName_;
@property (nonatomic, weak) id<NSFetchedResultsControllerDelegate> delegate_;
@property (nonatomic) NSArray *fetchedObjects_;
@property (nonatomic) NSArray *sectionIndexTitles_;
@property (nonatomic) NSArray *sections_;
@end


@implementation HHFixedResultsController (NSFetchedResultsController)
@dynamic fetchRequest, managedObjectContext, sectionNameKeyPath, cacheName, delegate, fetchedObjects, sectionIndexTitles, sections;

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name
{
    self = [self init];
    if (self)
    {
        self.fetchRequest_ = fetchRequest;
        self.managedObjectContext_ = context;
        self.sectionNameKeyPath_ = sectionNameKeyPath;
        self.cacheName_ = name;
    }
    return self;
}

- (BOOL)performFetch:(NSError **)error
{
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
    self.delegate_ = delegate;
}

+ (void)deleteCacheWithName:(NSString *)name
{
    
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
- (id)initWithPredicate:(NSPredicate *)predicate objects:(id)kvcObjects sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

