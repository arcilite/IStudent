//
//  BaseDataSorce.m
//  Bruegal
//
//  Created by Arcilite on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArcDataSource.h"
#import "Settings.h"

@implementation ArcDataSource
- (id) init {
    
    self = [super init];
    if(self) {
        
		[self loadCoreData];
		[self loadFetchedResultsControllers];
    }
    
    return self;
}

- (NSString *) modelFilePath {
    
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSFileManager *localFileManger = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManger enumeratorAtPath:mainBundlePath];
    
    NSString *file = nil;
    BOOL fileFound = NO;
    while (file = [dirEnum nextObject]) {
        if([[file pathExtension] isEqualToString:@"mom"]) {
            
            fileFound = YES;
            break;
        }
        if(fileFound)
            break;
    }
    
    [localFileManger release];
    
    modelName = fileFound ? [[file lastPathComponent] retain] : nil;
    return fileFound ? [mainBundlePath stringByAppendingPathComponent: file] : nil;
}

- (NSString *) dbSQLiteFilePath {
    
    //subclasses could overwrite
    return [APPLICATION_DOCUMENTS_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[modelName stringByDeletingPathExtension] stringByAppendingPathExtension:@"sqlite"]]];
    NSLog(@"%@",[APPLICATION_DOCUMENTS_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[modelName stringByDeletingPathExtension] stringByAppendingPathExtension:@"sqlite"]]]);
}

- (void) loadFetchedResultsControllers{
	arrayOfFRC = [[NSMutableArray alloc] init];
	NSArray * entities = [managedObjectModel entities];
	for (int i = 0 ; i< [entities count]; i++) {
		NSFetchedResultsController * frc = [self createFetchResultController:[entities objectAtIndex:i]];
		[arrayOfFRC addObject:frc];
		[frc release];
	}
}

- (NSFetchedResultsController *)createFetchResultController:(id) entity{
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	
	id o = [entity propertiesByName];
	NSString * default_sort = [[o objectForKey:[[o allKeys] objectAtIndex:0]] name];
	
	[request setEntity:[NSEntityDescription entityForName:[entity name] inManagedObjectContext:managedObjectContext]];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:default_sort ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[sortDescriptor release];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	
	NSFetchedResultsController * frc = [[ NSFetchedResultsController alloc] 
                                        initWithFetchRequest:request managedObjectContext:managedObjectContext 
                                        sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"CASH_%@",[entity name]]];
	NSError * error;
	if(![frc performFetch:&error])
		NSLog(@"%@",error);
	
	[request release];
	return frc;
}

- (void) loadCoreData {
    
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self modelFilePath]]];
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	
    NSString *sqlitefp = [self dbSQLiteFilePath];
    if(![[NSFileManager defaultManager]fileExistsAtPath:[sqlitefp stringByDeletingLastPathComponent]])
        [[NSFileManager defaultManager] createDirectoryAtPath:[sqlitefp stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    
	NSURL *storeURL = [NSURL fileURLWithPath:[self dbSQLiteFilePath]];
	
    NSError *error = nil;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
	else {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
	}	
}


#pragma mark - 
#pragma mark Методы работы с базой данных

- (void) reloadFetchedResultsControllers{
	for (int i = 0; i<[arrayOfFRC count]; i++) {
		NSFetchedResultsController * frc = [arrayOfFRC objectAtIndex:i];
		[NSFetchedResultsController deleteCacheWithName:frc.cacheName];
		[[arrayOfFRC objectAtIndex:i] performFetch:nil];
	}
}

- (NSFetchedResultsController *) getFetchedResultsControllerByName:(NSString *)objectName{
	
	for (NSFetchedResultsController * frc in arrayOfFRC) {
		NSString * className = [frc.cacheName stringByReplacingOccurrencesOfString:@"CASH_" withString:@""];
		
		if ([className isEqualToString:objectName])
			return frc;
	}
	
	return nil;
}

- (NSManagedObject *) createNew:(NSString *) entityName {
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	NSManagedObject *product = [[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext] autorelease];
	return product;
}

- (void) reloadFetchedResultsControllerByObjectName:(NSString *)objectName{
	NSFetchedResultsController * frc = [self getFetchedResultsControllerByName:objectName];
	[NSFetchedResultsController deleteCacheWithName:[NSString stringWithFormat:@"CASH_%@", objectName]];
	[frc performFetch:nil];
}

- (void) saveChanges{
	NSError * error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"%@",error);
	}
}

- (NSArray *) getAllByName:(NSString *)objectName{
	return [[self getFetchedResultsControllerByName:objectName] fetchedObjects];
}

- (NSArray *) getDataFromObject:(NSString *) objectName withSort:(NSString *)sortExpression{
	NSPredicate * pr = [NSPredicate predicateWithFormat:@"%@",sortExpression];
	return [[[self getFetchedResultsControllerByName:objectName] fetchedObjects] filteredArrayUsingPredicate:pr];
}

- (NSArray *) sortArray:(NSArray *) arr byKey:(NSString *)key ascending:(BOOL) ascending {
	
	if(!arr) return nil;
	if([arr count] == 0) return nil;
	
	NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
	NSArray *sortedValues = [arr sortedArrayUsingDescriptors:[NSMutableArray arrayWithObjects:sortDescriptor, nil]];
	[sortDescriptor release];
	
	return sortedValues;
}

-(void) dealloc{
	[arrayOfFRC release];
	[managedObjectModel release];
	[managedObjectContext release];
	[persistentStoreCoordinator release];
    [modelName release];
	[super dealloc];
}

@end
