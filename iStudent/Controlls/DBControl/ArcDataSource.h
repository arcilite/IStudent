//
//  BaseDataSorce.h
//  Bruegal
//
//  Created by Arcilite on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ArcDataSource : NSObject
{
	NSMutableArray * arrayOfFRC;
	NSManagedObjectModel * managedObjectModel;
	NSManagedObjectContext * managedObjectContext;
	NSPersistentStoreCoordinator * persistentStoreCoordinator;
    NSString *modelName;
}
/*!
 @discussion Selects all NSManagedObjects and for each creates NSFetchedResultsController, adds them to array arrayOfFRC
 */
- (void) loadFetchedResultsControllers;
/*!
 @discussion Initializes managedObjectModel, managedObjectContext, persistentStoreCoordinator. Loads db from sqlite to app.
 */
- (void) loadCoreData;
/*!
 @discussion Creates NSFetchedResultsController from given object entity (NSManagedObject).
 @param entity Object to create from.
 @result Created NSFetchedResultsController for given object.
 */
- (NSFetchedResultsController *)createFetchResultController:(id) entity;
/*!
 @discussion Returns NSFetchedResultsController for given name of object.
 @param  objectName Name of object.
 @result returns appropriate NSFetchedResultsController.
 */
- (NSFetchedResultsController *) getFetchedResultsControllerByName:(NSString *)objectName;
/*!
 @discussion Reloads all NSFetchedResultsController
 */
- (void) reloadFetchedResultsControllers;
/*!
 @discussion Creates new entity from given name 
 @param entityName Name of entity to create object from.
 @result Cretated instance of NSManagedObject.
 */
- (NSManagedObject *) createNew:(NSString *) entityName;
/*!
 @discussion reloads NSFetchedResultsController  by given name of entity
 @param objectName Name of object.
 */
- (void) reloadFetchedResultsControllerByObjectName:(NSString *)objectName;
/*!
 @discussion Saves all made changes with db.
 */
- (void) saveChanges;
/*!
 @discussion Returns all objects of entity with given name.
 @param objectName Given name of entity.
 @result array of objects from db.
 */
- (NSArray *) getAllByName:(NSString *)objectName;
/*!
 @discussion Returns array with ManagedObject objects sorted with sortExpression given.
 @param objectName Name of NSManagedObject
 @param sortExpression Sort expresstion.
 @result Array of objects.
 */
- (NSArray *) getDataFromObject:(NSString *) objectName withSort:(NSString *)sortExpression;
/*!
 @discussion Сортировка переданного массива по ключу.
 @param arr Массив для сортировки.
 @param key Поле по которому сортировать.
 @param ascend По возростанию или убыванию, YES - (A-Z), NO - (Z-A).
 @result Отсортированный массив.
 */
- (NSArray *) sortArray:(NSArray *) arr byKey:(NSString *)key ascending:(BOOL) ascending;
/*!
 @discussion Internal method. Searches .mom files in main bundle to load db scheme from.
 @result File path if found .mom file, otherwise nil.
 */
- (NSString *) modelFilePath;
/*!
 @discussion File path to save created sqlite or load from into application. Sublasses should overwrite.
 Default is path created with name of .mom file in application documents directory.
 @result 
 */
- (NSString *) dbSQLiteFilePath;


@end
