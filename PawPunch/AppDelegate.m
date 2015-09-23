//
//  AppDelegate.m
//  PawPunch
//
//  Created by Amir Saifi on 9/15/15.
//  Copyright (c) 2015 Amir Saifi. All rights reserved.
//

#import "AppDelegate.h"
#import "PHBusiness.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"Qxi7pgAFaysRDr9Hr9w3lHob18hvYVlRQfLoJ6bn"
                  clientKey:@"vU0EyATtNS7dFzbnlpsPiXyNHMZMPoXyTySOmAa1"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    PFQuery *businessQuery = [PFQuery queryWithClassName:@"Business"];
    NSArray *busData = [businessQuery findObjects];
    
    _myPlaces = [[NSMutableArray alloc] initWithCapacity:[busData count]];
    
    for(PFObject *temp in busData)
    {
        PHBusiness *next = [[PHBusiness alloc]init];
        next.objID = temp.objectId;
        next.name = temp[@"businessName"];
        next.rewardDescription = temp[@"rewardDescription"];
        next.punchesReq = temp[@"punchesRequired"];
        next.punchesEarned = temp[@"punchesEarned"];
        next.prevCustomer = (BOOL) temp[@"prevCustomer"];
        next.address = temp[@"Address"];
        
        NSLog(@"%@",next.name);
        [_myPlaces addObject:next];
        
    }
    NSLog(@"Done Querying");
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
