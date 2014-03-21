//
//  HHFixedResultsController.h
//  HHFixedResultsController
//
//  Created by hyukhur on 2014. 3. 11..
//  Copyright (c) 2014년 hyukhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSFetchRequest;


@interface HHFixedResultsController : NSObject
@property (nonatomic, readonly) id objects;
- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest objects:(id)kvcObjects sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;
- (void)addObject:(id)objects;
@end


@class NSManagedObjectContext;
@protocol NSFetchedResultsControllerDelegate;

/*
 NSFetchedResultsController.h
 Core Data
 Copyright (c) 2009-2012 Apple Inc.
 All rights reserved.
 
 Class Overview
 ==============
 
 This class is intended to efficiently manage the results returned from a Core Data fetch request.
 
 You configure an instance of this class using a fetch request that specifies the entity, optionally a filter predicate, and an array containing at least one sort ordering. When you execute the fetch, the instance efficiently collects information about the results without the need to bring all the result objects into memory at the same time. As you access the results, objects are automatically faulted into memory in batches to match likely access patterns, and objects from previous accessed disposed of. This behavior further serves to keep memory requirements low, so even if you traverse a collection containing tens of thousands of objects, you should never have more than tens of them in memory at the same time.
 
 This class is tailored to work in conjunction with UITableView, however you are free to use it with your own views. UITableView expects its data source to present the results as an array of sections made up of rows. NSFetchedResultsController can efficiently analyze the result of the fetch request and pre-compute all the information about sections in the result set. Moreover, the controller can cache the results of this computation so that if the same data is subsequently re-displayed, the work does not have to be repeated. In addition:
 * The controller monitors changes to objects in its associated managed object context, and updates the results accordingly. It reports changes in the results set to its delegate.
 * The controller automatically purges unneeded objects if it receives an application low memory notification.
 * The controller maintains a persistent cache of the section information across application launches if the cacheName is not nil.  If caching is enabled, you must not mutate the fetch request, its predicate, or its sort descriptor without first calling +deleteCacheWithName:
 
 Typical use
 ===========
 
 Developers create an instance of NSFetchedResultsController and configure it with a fetchRequest.  It is expected that the sort descriptor used in the request groups the results into sections. This allows for section information to be pre-computed.
 After creating an instance, the performFetch: method should be called to actually perform the fetching.
 Once configured, this class can be a helper class when implementing the following methods from the UITableViewDataSource protocol
 
 - (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
 - (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
 
 The instance of NSFetchedResultsController also registers to receive change notifications on the managed object context that holds the fetched objects. Any change in the context that affects the result set or section information is properly processed. A delegate can be set on the class so that it's also notified when the result objects have changed. This would typically be used to update the display of the table view.
 WARNING: The controller only performs change tracking if a delegate is set and responds to any of the change tracking notification methods.  See the NSFetchedResultsControllerDelegate protocol for which delegate methods are change tracking.
 
 Handling of Invalidated Objects
 ===============================
 
 When a managed object context notifies the NSFetchedResultsController of individual objects being invalidated (NSInvalidatedObjectsKey), the controller treats these as deleted objects and sends the proper delegate calls.
 It's possible for all the objects in a managed object context to be invalidated simultaneously. This can happen as a result of calling -reset on NSManagedObjectContext, or if a store is removed from the the NSPersistentStoreCoordinator. When this happens, NSFetchedResultsController currently does not invalidate all objects, nor does it send individual notifications for object deletions. Instead, developers must call performFetch: again to reset the state of the controller if all the objects in a context have been invalidated. They should also reload all their data in the UITableView.
 
 */

@interface HHFixedResultsController (NSFetchedResultsController)
/* ========================================================*/
/* ========================= INITIALIZERS ====================*/
/* ========================================================*/

/* Initializes an instance of NSFetchedResultsController
 fetchRequest - the fetch request used to get the objects. It's expected that the sort descriptor used in the request groups the objects into sections.
 context - the context that will hold the fetched objects
 sectionNameKeyPath - keypath on resulting objects that returns the section name. This will be used to pre-compute the section information.
 cacheName - Section info is cached persistently to a private file under this name. Cached sections are checked to see if the time stamp matches the store, but not if you have illegally mutated the readonly fetch request, predicate, or sort descriptor.
 */
- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;

/* Executes the fetch request on the store to get objects.
 Returns YES if successful or NO (and an error) if a problem occurred.
 An error is returned if the fetch request specified doesn't include a sort descriptor that uses sectionNameKeyPath.
 After executing this method, the fetched objects can be accessed with the property 'fetchedObjects'
 */
- (BOOL)performFetch:(NSError **)error;

/* ========================================================*/
/* ====================== CONFIGURATION ===================*/
/* ========================================================*/

/* NSFetchRequest instance used to do the fetching. You must not change it, its predicate, or its sort descriptor after initialization without disabling caching or calling +deleteCacheWithName.  The sort descriptor used in the request groups objects into sections.
 */
@property (nonatomic, readonly) NSFetchRequest *fetchRequest;

/* Managed Object Context used to fetch objects. The controller registers to listen to change notifications on this context and properly update its result set and section information.
 */
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

/* The keyPath on the fetched objects used to determine the section they belong to.
 */
@property (nonatomic, readonly) NSString *sectionNameKeyPath;

/* Name of the persistent cached section information. Use nil to disable persistent caching, or +deleteCacheWithName to clear a cache.
 */
@property (nonatomic, readonly) NSString *cacheName;

/* Delegate that is notified when the result set changes.
 */
@property(nonatomic, assign) id< NSFetchedResultsControllerDelegate > delegate;

/* Deletes the cached section information with the given name.
 If name is nil, then all caches are deleted.
 */
+ (void)deleteCacheWithName:(NSString *)name;

/* ========================================================*/
/* ============= ACCESSING OBJECT RESULTS =================*/
/* ========================================================*/

/* Returns the results of the fetch.
 Returns nil if the performFetch: hasn't been called.
 */
@property  (nonatomic, readonly) NSArray *fetchedObjects;

/* Returns the fetched object at a given indexPath.
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/* Returns the indexPath of a given object.
 */
-(NSIndexPath *)indexPathForObject:(id)object;

/* ========================================================*/
/* =========== CONFIGURING SECTION INFORMATION ============*/
/* ========================================================*/
/*	These are meant to be optionally overridden by developers.
 */

/* Returns the corresponding section index entry for a given section name.
 Default implementation returns the capitalized first letter of the section name.
 Developers that need different behavior can implement the delegate method -(NSString*)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName
 Only needed if a section index is used.
 */
- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName;

/* Returns the array of section index titles.
 It's expected that developers call this method when implementing UITableViewDataSource's
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
 
 The default implementation returns the array created by calling sectionIndexTitleForSectionName: on all the known sections.
 Developers should override this method if they wish to return a different array for the section index.
 Only needed if a section index is used.
 */
@property (nonatomic, readonly) NSArray *sectionIndexTitles;

/* ========================================================*/
/* =========== QUERYING SECTION INFORMATION ===============*/
/* ========================================================*/

/* Returns an array of objects that implement the NSFetchedResultsSectionInfo protocol.
 It's expected that developers use the returned array when implementing the following methods of the UITableViewDataSource protocol
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
 - (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
 
 */
@property (nonatomic, readonly) NSArray *sections;

/* Returns the section number for a given section title and index in the section index.
 It's expected that developers call this method when executing UITableViewDataSource's
 - (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
 */
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;

@end