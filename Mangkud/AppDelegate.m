//
//  AppDelegate.m
//  Mangkud
//
//  Created by Firststep Consulting on 21/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "ATAppUpdater.h"
#import <UserNotifications/UserNotifications.h>
#import "NewsList.h"
#import "CheckInOut.h"
#import "Leave.h"
#import "Salary.h"
#import "Agenda.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate () <ATAppUpdaterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

@synthesize fontSize,fontRegular,fontLight,fontMedium,fontSemibold,fontBold;

@synthesize loginStatus,userID,adminID,userFullname,userLogoUrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    loginStatus = [ud boolForKey:@"loginStatus"];
    userID = [ud objectForKey:@"userID"];
    adminID = [ud objectForKey:@"adminID"];
    userFullname = [ud objectForKey:@"userFullname"];
    userLogoUrl = [ud objectForKey:@"userLogoUrl"];
    
    //loginStatus = NO;
    //loginStatus = YES;
    //userID = @"3";
    //adminID = @"27";
    //userFullname = @"ตรรก คาระวะวัฒนา";
    
    
    fontRegular = @"Kanit-Regular";
    fontLight = @"Kanit-Light";
    fontMedium = @"Kanit-Medium";
    fontSemibold = @"Kanit-SemiBold";
    fontBold = @"Kanit-Bold";
    
    [SVProgressHUD setBorderColor:[UIColor lightGrayColor]];
    [SVProgressHUD setBorderWidth:1.0];
    
    ATAppUpdater *updater = [ATAppUpdater sharedUpdater];
    [updater setAlertTitle:NSLocalizedString(@"New Version", @"Alert Title")];
    [updater setAlertMessage:NSLocalizedString(@"Mangkud %@ is available on the AppStore.", @"Alert Message")];
    [updater setAlertUpdateButtonTitle:@"Update"];
    [updater setAlertCancelButtonTitle:@"Not Now"];
    [updater setDelegate:self]; // Optional
    //[updater showUpdateWithConfirmation];
    [updater showUpdateWithForce];
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckConnection" object:reach];
        });
    };
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
    };
    [reach startNotifier];
    
    [self setUpRoot];
    
    sleep(2);
    return YES;
}

- (void)setUpRoot
{
    container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    
    if (IS_IPHONE) {
        [container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.7];
        //[container setRightMenuWidth:[UIScreen mainScreen].bounds.size.width*0.80];
        //NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
        float factor = [UIScreen mainScreen].bounds.size.width/320;
        fontSize = 13*factor;
    }
    if (IS_IPAD) {
        [container setLeftMenuWidth:[UIScreen mainScreen].bounds.size.width*0.4];
        float factor = [UIScreen mainScreen].bounds.size.width/768;
        fontSize = 25*factor;
    }
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    //UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
    
    if (loginStatus == YES) {
        [self setUpTabBar];
    }
    else{
        UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [container setLeftMenuViewController:leftSideMenuViewController];
        [container setCenterViewController:login];
    }
}

- (void) setUpTabBar {
    Agenda *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"Agenda"];
    //firstViewController.title = @"First View";
    firstViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"หน้าแรก" image:[UIImage imageNamed:@"Tab_home.png"] tag:0];
    //[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    UINavigationController *firstNavController = [[UINavigationController alloc]initWithRootViewController:firstViewController];
    firstNavController.navigationBarHidden = YES;
    
    CheckInOut *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckInOut"];
   secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"เวลาเข้างาน" image:[UIImage imageNamed:@"Tab_time.png"] tag:1];
    UINavigationController *secondNavController = [[UINavigationController alloc]initWithRootViewController:secondViewController];
    secondNavController.navigationBarHidden = YES;
    
    Leave *thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"Leave"];
    thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ข้อมูลการลา" image:[UIImage imageNamed:@"Tab_calendar.png"] tag:2];
    UINavigationController *thirdNavController = [[UINavigationController alloc]initWithRootViewController:thirdViewController];
    thirdNavController.navigationBarHidden = YES;
    
    Salary *forthViewController = [storyboard instantiateViewControllerWithIdentifier:@"Salary"];
    //forthViewController.title = @"Forth View";
    forthViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"บัญชีเงินเดือน" image:[UIImage imageNamed:@"Tab_salary.png"] tag:3];
    UINavigationController *forthNavController = [[UINavigationController alloc]initWithRootViewController:forthViewController];
    forthNavController.navigationBarHidden = YES;
    
    tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabbarController"];//[[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:firstNavController, secondNavController, thirdNavController, forthNavController, nil];
    //tabBarController.tabBar.tintColor = [UIColor colorWithRed:169.0/255 green:79.0/255 blue:123.0/255 alpha:1];
    //tabBarController.delegate = self;
    
    //[tabbarController setSelectedIndex:1]; Start With Tab X
    [container setLeftMenuViewController:leftSideMenuViewController];
    //[container setRightMenuViewController:rightSideMenuViewController];
    [container setCenterViewController:tabBarController];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckConnection" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
