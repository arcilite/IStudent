//
//  DataSource.h
//  Bruegal
//
//  Created by StableFlow on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcDataSource.h"
#import "JSONDataParser.h"
#import "Topics.h"
#import "Categories.h"
#import "Authors.h"
#import"Posts.h"

@interface DataSource : ArcDataSource{
    JSONDataParser *jsonParser;
}
@property (nonatomic,retain) JSONDataParser *jsonParser;
-(void)loadJSONtoDB:(NSDictionary*)json;

-(void)saveAuthors:(NSDictionary*)authors;
-(void)saveTopics:(NSDictionary*)topics;
-(void)saveCategories:(NSDictionary*)categories;
-(NSArray*)getAllPosts;
-(NSArray*)getPostsByType:(NSString*)type;
- (NSString *)getTopicStringForPost:(Posts *)post;
-(BOOL)IsDBUpToDate:(NSDictionary*)json;
-(NSArray*)getRangePostsByType:(NSString*)type range:(NSRange)range;
- (NSString *)getAuthorsStringForPost:(Posts *)post;
- (NSString *)getCategoriesStringForPost:(Posts *)post;

-(BOOL)isFavorite:(Posts*)post;
-(void)uncheckFavorite:(Posts*)post;
-(void)checkFavorite:(Posts*)post;
- (void) setFavorite:(Posts*)post fav:(BOOL)yes;
-(NSArray*)getAllFavorites:(NSString *)type;
-(NSArray*)searchByTextFromAll:(NSString*)searchString type:(NSDictionary*)type;
-(NSArray*)getRangePostsByTopic:(NSString*)type range:(NSRange)range title:(NSString*)title;
-(NSArray*)getRangePostsByTopic:(NSString*)type range:(NSRange)range title:(NSString*)title;
@end
