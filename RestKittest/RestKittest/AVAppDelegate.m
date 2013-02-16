//
//  AVAppDelegate.m
//  RestKittest
//
//  Created by Max on 12.02.13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import "AVAppDelegate.h"
#import "Articale.h"


@implementation AVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self secondRestKitExample];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)firstRestKitExample{
    //Simple parsing of JSON to object
    RKObjectMapping *articaleMapping = [RKObjectMapping mappingForClass:[Articale class]];
    [articaleMapping addAttributeMappingsFromDictionary:
     @{@"title": @"title",
     @"body" : @"body",
     @"author" : @"author",
     @"publiction_date": @"publicationDate"
     }];
    RKResponseDescriptor *articaleDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:articaleMapping pathPattern:nil keyPath:@"articles" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:@"http://localhost:8888/first_example.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[articaleDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}


- (void)secondRestKitExample{
    //Simple parsing JSON to object that containes another object Articale containes Author
    //Author
    RKObjectMapping* authorMapping = [RKObjectMapping mappingForClass:[Author class] ];
    // NOTE: When your source and destination key paths are symmetrical, you can use mapAttributes: as a shortcut
    [authorMapping addAttributeMappingsFromArray:@[@"name", @"email"]];
    
    
    RKObjectMapping *articaleMapping = [RKObjectMapping mappingForClass:[Articale class]];
    [articaleMapping addAttributeMappingsFromDictionary:
     @{@"title": @"title",
     @"body" : @"body",
     @"publiction_date": @"publicationDate"
     }];
    
    [articaleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"author" toKeyPath:@"author" withMapping:authorMapping]];
    RKResponseDescriptor *articaleDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:articaleMapping pathPattern:nil keyPath:@"articles" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectMapping *backArticaleMapping = [articaleMapping inverseMapping];
    
    NSURL *URL = [NSURL URLWithString:@"http://localhost:8888/second_example.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[articaleDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Articles: %@", mappingResult.array);
        for (Articale *articale in mappingResult.array) {
            NSLog(@"Articale title = %@ body %@ DATE[%@] Autor name %@ Author email %@", articale.title, articale.body, articale.publicationDate, articale.author.name, articale.author.email);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}



@end
