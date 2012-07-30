//
//  DataSource.m
//  Bruegal
//
//  Created by StableFlow on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"
#import "Posts.h"
@interface DataSource()
-(void)addAuthorsToPosts:(NSArray*)authorsArray post:(Posts*)post;
-(void)addTopicsToPosts:(NSArray*)topicsArray post:(Posts*)post;
-(void)addCategoriesToPosts:(NSArray*)postsArray post:(Posts*)post;
- (Posts*) getPostForId:(NSString*)Id type:(NSString*)type ;
- (Authors*) getAuthorForId:(NSString*)Id;
- (Topics*) getTopicsForId:(NSString*)Id;
- (Categories*) getCategoriesForId:(NSString*)Id;
@end

@implementation DataSource
@synthesize jsonParser;
- (id) init
{
	self = [super init];
	if(self) {
       [self loadCoreData];
       [self loadFetchedResultsControllers];
        jsonParser=[[JSONDataParser alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
    [jsonParser release],jsonParser = nil;
    [super dealloc];
}

-(BOOL)IsDBUpToDate:(NSDictionary*)json
{
    if(json)
    {
        NSArray *posts=[jsonParser getPostsArray:json];
        NSDictionary * dic=[posts lastObject];
        //NSLog(@"duc%@",dic);
          if([self getPostForId:[dic objectForKey: @"id"] type:[dic objectForKey: @"type"]]!=nil){
                        
              return YES;
           }
    }
    return NO;
}

-(void)loadJSONtoDB:(NSDictionary*)json
{
    [self reloadFetchedResultsControllers];
    //NSLog(@"json %@",json);
    if(json)
    {
       NSArray *posts=[jsonParser getPostsArray:json];
        for (int i=0;i<[posts count]; i++)
        {   
            NSDictionary * dic=[posts objectAtIndex:i];
            
            if([self getPostForId:[dic objectForKey: @"id"] type:[dic objectForKey: @"type"]]==nil){
           
                Posts * post = (Posts *)[self createNew:@"Posts"];
                post.iD= [NSNumber numberWithInteger:[[dic objectForKey: @"id"] integerValue]];
                post.crdate=[dic objectForKey: @"crdate"];
                post.eventdate=[dic objectForKey: @"eventdate"];
                post.full_text=[dic objectForKey: @"full_text"];
                post.image=[dic objectForKey: @"image"];
                post.location=[dic objectForKey: @"location"];
                post.moddate=[dic objectForKey: @"modtdate"];
                post.pdf=[[dic objectForKey: @"pdf"] lastObject];
                post.preview_text=[dic objectForKey: @"preview_text"];
                post.regclosedate=[dic objectForKey: @"regclosedate"];
                post.title=[dic objectForKey: @"title"];
                post.type=[dic objectForKey: @"type"];
                post.url=[dic objectForKey: @"url"];
                post.video=[dic objectForKey: @"video"];
                NSLog(@"%@",[dic objectForKey: @"video"]);
                NSInteger myValue = 0;
                post.favorites=[NSNumber numberWithInteger: myValue];
               
                NSArray*authorsArray=[dic objectForKey:@"authors"];
                if ([authorsArray count]>0) {
                    [self addAuthorsToPosts:authorsArray post:post]; 
                }
                NSArray*topicsArray=[dic objectForKey:@"topics"];
                if ([topicsArray count]>0) {
                    [self addTopicsToPosts:topicsArray post:post];
                }
                NSArray*categoriesArray=[dic objectForKey:@"categories"];
                if ([categoriesArray count]>0) {
                    [self addCategoriesToPosts:categoriesArray post:post];
                }
            }
        }
        
        [self saveChanges];
        [self reloadFetchedResultsControllers];
    }
}

-(void)addAuthorsToPosts:(NSArray*)authorsArray post:(Posts*)post
{
    if ([authorsArray count]>0&&post) {
        
        for (int i=0;i<[authorsArray count]; i++)
        {
            NSString * authorId=[authorsArray objectAtIndex:i];
            Authors * author = [self getAuthorForId:authorId];
            if (author) {
                [author addPosts:[NSSet setWithObject:post]];
                [post addAuthors:[NSSet setWithObject:author]];
            }
        
        
        }
    }

}

-(void)addTopicsToPosts:(NSArray*)topicsArray post:(Posts*)post
{
    
    for (int i=0;i<[topicsArray count]; i++)
    {
        
        NSString *topicId=[topicsArray objectAtIndex:i];
    
        Topics* topic = (Topics *)[self getTopicsForId:topicId];
        if(topic){
            [topic addPosts:[NSSet setWithObject:post]];
            [post addTopics:[NSSet setWithObject:topic]];
        }
    }
}

-(void)addCategoriesToPosts:(NSArray*)categoriesArray post:(Posts*)post
{
    for (int i=0;i<[categoriesArray count]; i++)
    {    
        NSString *categoriesId=[categoriesArray objectAtIndex:i];
        Categories* categories = (Categories *)[self  getCategoriesForId:categoriesId];
        if(categories){
            [categories addPosts:[NSSet setWithObject:post]];
            [post addCategories:[NSSet setWithObject:categories]];
        }
        
    }
}

#pragma mark-
#pragma mark save tables

-(void)saveAuthors:(NSDictionary*)authors 
{
    NSArray *authorsArray=[authors objectForKey:@"authors"];
    for (int i=0;i<[authorsArray count]; i++)
    {
        NSDictionary * dic=[authorsArray objectAtIndex:i];
        
           if([self getAuthorForId:[dic objectForKey: @"id"]]==nil)
           {
                Authors * author = (Authors *)[self createNew:@"Authors"];
                author.iD=[NSNumber numberWithInteger:[[dic objectForKey: @"id"] integerValue]];
                author.moddate=[dic objectForKey: @"modtdate"];
                author.title=[dic objectForKey:@"title"];
            }
    }
    
    [self saveChanges];
    [self reloadFetchedResultsControllers];
}

-(void)saveTopics:(NSDictionary*)topics
{
    NSArray *topicsArray =[topics objectForKey:@"topics"];
    for (int i=0;i<[topicsArray count]; i++)
    {
        NSDictionary * dic=[topicsArray objectAtIndex:i];
        
        if ([dic objectForKey: @"id"]!=nil) 
        {
            if([self getTopicsForId:[dic objectForKey: @"id"]]==nil)
            {
            Topics* topic = (Topics *)[self createNew:@"Topics"];
            topic.iD=[NSNumber numberWithInteger:[[dic objectForKey: @"id"] integerValue]];
            NSString *modDateString = [dic objectForKey: @"modtdate"];
            topic.moddate=modDateString;
            topic.title=[dic objectForKey:@"title"];
            }
        }
    }
    [self saveChanges];
    [self reloadFetchedResultsControllers];

}

-(void)saveCategories:(NSDictionary*)categories
{
    NSArray *categoriesArray =[categories objectForKey:@"categories"];
    for (int i=0;i<[categoriesArray count]; i++)
    {   
        NSDictionary * dic=[categoriesArray objectAtIndex:i];
      
        if ([dic objectForKey: @"id"]!=nil) {
            if([self getCategoriesForId:[dic objectForKey: @"id"]]==nil){
            Categories* categories = (Categories *)[self createNew:@"Categories"];
            categories.iD=[NSNumber numberWithInteger:[[dic objectForKey: @"id"] integerValue]];
            categories.moddate=[dic objectForKey: @"modtdate"];
            categories.title=[dic objectForKey:@"title"];
            }
        }
        
    }
    [self saveChanges];
    [self reloadFetchedResultsControllers];
}


- (NSArray *) sortArray:(NSArray *) arr byKey:(NSString *)key ascending:(BOOL) ascend{
	
	if(!arr) return nil;
	if([arr count] == 0) return nil;
	
	NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascend];
	NSArray *sortedValues = [arr sortedArrayUsingDescriptors:[NSMutableArray arrayWithObjects:sortDescriptor, nil]];
	[sortDescriptor release];
	
	return sortedValues;
}

- (Posts*) getPostForId:(NSString*)Id type:(NSString*)type {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD==%@ AND type LIKE %@",Id,type];
	NSArray *posts = [self getAllByName:@"Posts"];
    
	Posts *post = nil;
	if([posts count] > 0) {
      
            NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
            post = [arr lastObject];
            
            return post;
       
	}	
    return nil;
   
}

- (Authors*) getAuthorForId:(NSString*)Id {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD==%@",Id];
	NSArray *posts = [self getAllByName:@"Authors"];
	Authors *post = nil;
	if([posts count] > 0) {
		NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
        
        post = [arr lastObject];
        
	}	
    return post;
}


- (Categories*) getCategoriesForId:(NSString*)Id {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD==%@",Id];
	NSArray *posts = [self getAllByName:@"Categories"];

	Categories *post = nil;
	if([posts count] > 0) {
		NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
        post = [arr lastObject];
        
	}	
    return post;
}

- (Topics*) getTopicsForId:(NSString*)Id {
   // NSLog(@"%@",Id);
  
    // NSLog(@"%@",ID);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD==%@", Id];
    
	NSArray *posts = [self getAllByName:@"Topics"];
   
	Topics *post = nil;
	if([posts count] > 0) {
		NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
        post = [arr lastObject];
        
	}	
    return post;
}

-(NSArray*)getPostsByType:(NSString*)type{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"type", type];
	NSArray *posts = [self getAllByName:@"Posts"];
    NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
    NSArray *sortedArr = [self sortArray:arr byKey:@"iD" ascending:NO];
    return sortedArr;
}

-(NSArray*)getRangePostsByType:(NSString*)type range:(NSRange)range
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"type", type];
	NSArray *posts = [self getAllByName:@"Posts"];
    NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
    NSArray *sortedArr=[self sortArray:arr byKey:@"iD" ascending:NO];
    
    if ((range.location+range.length)>[arr count]) {
        return sortedArr;
    }
    
    NSArray* tenArr=[sortedArr subarrayWithRange:range];
    return tenArr;
}

-(NSArray*)getAllPosts {
    
	NSArray *posts = [self getAllByName:@"Posts"];
    NSArray *sortedArr = [self sortArray:posts byKey:@"iD" ascending:NO];
    return sortedArr;
}

- (NSArray *) getObject:(NSString *)_objectName key:(NSString *)_key value:(NSString *) value expression:(NSString *) _expression{
	NSArray * arr = [self getAllByName:_objectName];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K %@ %@",_key,_expression, value];
	return [arr filteredArrayUsingPredicate:predicate];
}

- (NSManagedObject *) getObject:(NSString *)_objectName key:(NSString *)_key value:(NSString *) _value{
	NSArray * arr = [self getAllByName:_objectName];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",_key,_value];
	NSArray * result = [arr filteredArrayUsingPredicate:predicate];
	if ([result count] == 1) 
		return [result objectAtIndex:0];
	else 
		return nil;
}

#pragma mark- get  from post

-(NSArray*)getCategoriesFromPost:(Posts*)post{
    return  [post.categories allObjects];
}


-(NSArray*)getTopicsFromPost:(Posts*)post{
    return  [post.topics allObjects]; 
}

-(NSArray*)getAutorsFromPost:(Posts*)post{
    
    return  [post.authors allObjects];
}

#pragma mark
#pragma mark- get string from post

- (NSString *)getTopicStringForPost:(Posts *)post {
    NSMutableString *resultString = [[[NSMutableString alloc] init] autorelease];
    NSArray *array = [self getTopicsFromPost:post];
    
    for (Topics *topic in array) {
        if ([topic isEqual:[array objectAtIndex:0]]) {
            [resultString setString:[NSString stringWithFormat:@"%@",topic.title]];
        } else {
            [resultString setString:[NSString stringWithFormat:@"%@, %@",resultString,topic.title]];
        }
        
    }
    return resultString;
}

- (NSString *)getAuthorsStringForPost:(Posts *)post {
    NSMutableString *resultString = [[[NSMutableString alloc] init] autorelease];
    NSArray *array = [self getCategoriesFromPost:post];
    
    for (Topics *topic in array) {
        if ([topic isEqual:[array objectAtIndex:0]]) {
            [resultString setString:[NSString stringWithFormat:@"%@",topic.title]];
        } else {
            [resultString setString:[NSString stringWithFormat:@"%@, %@",resultString,topic.title]];
        }
        
    }
    return resultString;
}

- (NSString *)getCategoriesStringForPost:(Posts *)post {
    NSMutableString *resultString = [[[NSMutableString alloc] init] autorelease];
    NSArray *array = [self getTopicsFromPost:post];
    
    for (Topics *topic in array) {
        if ([topic isEqual:[array objectAtIndex:0]]) {
            [resultString setString:[NSString stringWithFormat:@"%@",topic.title]];
        } else {
            [resultString setString:[NSString stringWithFormat:@"%@, %@",resultString,topic.title]];
        }
        
    }
    return resultString;
}

#pragma mark-
#pragma mark work with favorites 
-(void)checkFavorite:(Posts*)post{
    NSInteger myValue = 1;
    post.favorites=[NSNumber numberWithInteger: myValue];
    [self saveChanges];
    [self reloadFetchedResultsControllers];
    
}
-(void)uncheckFavorite:(Posts*)post{
    NSInteger myValue = 0;
    post.favorites=[NSNumber numberWithInteger: myValue];
    [self saveChanges];
    [self reloadFetchedResultsControllers];

}

- (void) setFavorite:(Posts*)post fav:(BOOL)yes 
{
    NSInteger myValue;
    if (yes) 
    {
        myValue = 1;
    } else 
    {
        myValue = 0;
    }
    post.favorites=[NSNumber numberWithInteger: myValue];
    [self saveChanges];
    [self reloadFetchedResultsControllers];
}

-(BOOL)isFavorite:(Posts*)post
{
    
    if([post.favorites intValue]>0)
    {
        return YES;
    
    }else
    {
        return NO;
    }
}

-(NSArray*)getAllFavorites:(NSString *)type 
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorites==%i AND type LIKE %@", 1,type];
	NSArray *posts = [self getAllByName:@"Posts"];
    
	NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
	NSArray *sortedArr = [self sortArray:arr byKey:@"iD" ascending:NO];
    
    return sortedArr;
}

#pragma mark 
#pragma mark- find text

-(NSArray*)searchByTextFromAll:(NSString*)searchString type:(NSDictionary*)type
{
    NSArray * foundedArr;
    NSArray * postsArray=[self getAllPosts];
    if ([searchString length]>0) 
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"full_text CONTAINS %@ OR title CONTAINS %@ ",searchString,searchString];
        foundedArr = [postsArray filteredArrayUsingPredicate:predicate];
    }
    else
    {
        foundedArr=postsArray;
    }
    
    if ([type objectForKey:@"Type"]) 
    {
        if (![[type objectForKey:@"Type"] isEqual: @"All"]) 
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"type", [type objectForKey:@"Type"]];
            foundedArr = [foundedArr filteredArrayUsingPredicate:predicate];
        }
    }
    
    if ([type objectForKey:@"Author"])
    {
        if (![[type objectForKey:@"Author"]isEqual:@"All"])
        {
           NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(0!=SUBQUERY(authors,$eachPosts,$eachPosts.title=%@).@count)",[type objectForKey:@"Author"]];
            foundedArr = [foundedArr filteredArrayUsingPredicate:predicate];
        }
    }
    if (![[type objectForKey:@"Category"]isEqual:@"All"])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(0!=SUBQUERY(categories,$eachPosts,$eachPosts.title=%@).@count)",[type objectForKey:@"Category"]];
        foundedArr = [foundedArr filteredArrayUsingPredicate:predicate];
    }
    
    if ([type objectForKey:@"Topic"]) 
    {
        if (![[type objectForKey:@"Topic"]isEqual:@"All"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(0!=SUBQUERY(topics,$eachPosts,$eachPosts.title=%@).@count)",[type objectForKey:@"Topic"]];
            foundedArr = [foundedArr filteredArrayUsingPredicate:predicate];
        }
       
    }
    
    if ([type objectForKey:@"Year"])
    {
       
        if (![[type objectForKey:@"Year"]isEqual:@"All"])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"crdate", [type objectForKey:@"Year"]];
            foundedArr = [foundedArr filteredArrayUsingPredicate:predicate];
        }

    }
    
   
    return foundedArr;
    
}

-(NSArray*)getRangePostsByTopic:(NSString*)type range:(NSRange)range ID:(NSString*)Id
{
    //Topics *topc=[self  getTopicsForId:Id];
    //NSLog(@"top%@",topc);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"type", type];
	//NSArray *posts = [topc.posts allObjects];
    NSArray *posts = [self getAllByName:@"Posts"];
    // NSLog(@"p%@",posts);
    NSArray * arr = [posts filteredArrayUsingPredicate:predicate];
     NSPredicate *predicateid = [NSPredicate predicateWithFormat:@"iD==%@",Id];
    arr=[arr filteredArrayUsingPredicate:predicateid];
    
    NSArray *sortedArr=[self sortArray:arr byKey:@"iD" ascending:NO];
    
    if ((range.location+range.length)>[arr count]) {
        return sortedArr;
    }
    if ([Id isEqualToString:@"0"]) {
        return  [self getPostsByType:type];
    }
    NSArray* tenArr=[sortedArr subarrayWithRange:range];
    return tenArr;
}

-(NSArray*)getRangePostsByTopic:(NSString*)type range:(NSRange)range title:(NSString*)title
{
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:title,@"Topic",@"All",@"Author",@"All",@"Year",@"All",@"Category",type,@"Type",nil]; 
    NSArray *arr=[self searchByTextFromAll:nil type:dic];
    NSArray *sortedArr=[self sortArray:arr byKey:@"iD" ascending:NO];
    if ((range.location+range.length)>[sortedArr count]) {
        [dic release];
        return sortedArr;
    }
       
    NSArray* tenArr = [sortedArr subarrayWithRange:range];
    [dic release];
    return tenArr;
}

@end
