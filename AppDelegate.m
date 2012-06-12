//
//  AppDelegate.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PeopleViewController.h"


@implementation AppDelegate
{
    NSMutableArray *peopleArray;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Build the data array.
    //Read in the PeopleArray file.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"PeopleArray"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
    if (fileExists)
    {
        [self loadDataFromDisk];
    }
    else {
        NSLog(@"Creating a new people array.");
        peopleArray = [[NSMutableArray alloc] init];
    }
    
    //Get access to the rootviewcontroller and assign access to the data array being used.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    PeopleViewController *peopleViewController = [navigationController.viewControllers objectAtIndex:0];
    peopleViewController.peopleArray = peopleArray;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    // Save the array to local file in the documents.
    [self saveDataToDisk];
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
    
    // Save the array to local file in the documents.
    [self saveDataToDisk];
}

#pragma mark - Read/Save Data Methods

- (void) saveDataToDisk { 
	NSLog(@"Saving Array");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"PeopleArray"];
    
	NSMutableData *data = [NSMutableData data];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
	
	[archiver encodeObject:peopleArray forKey:@"PeopleArray"];
	[archiver finishEncoding];
	
	[data writeToFile:appFile atomically:YES];
    
	NSLog(@"Save OK");
    
} 


- (void) loadDataFromDisk { 
	NSLog(@"Load Array");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"PeopleArray"];
    
	NSMutableData *data = [NSData dataWithContentsOfFile:appFile];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
	peopleArray = [unarchiver decodeObjectForKey:@"PeopleArray"];
	[unarchiver finishDecoding];
}

@end
