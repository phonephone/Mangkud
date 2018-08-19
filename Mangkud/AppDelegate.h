//
//  AppDelegate.h
//  Mangkud
//
//  Created by Firststep Consulting on 21/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"
#import "MFSideMenuContainerViewController.h"
#import "Reachability.h"

#define HOST_DOMAIN @"http://mangkud.co/index.php?MobileApi/"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController *tabBarController;
    UIViewController *leftSideMenuViewController;
    MFSideMenuContainerViewController *container;
    UIStoryboard *storyboard;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) float fontSize;
@property (nonatomic) NSString *fontRegular;
@property (nonatomic) NSString *fontLight;
@property (nonatomic) NSString *fontMedium;
@property (nonatomic) NSString *fontSemibold;
@property (nonatomic) NSString *fontBold;

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *adminID;
@property (nonatomic) NSString *userLogoUrl;
@property (nonatomic) NSString *userFullname;

@property (nonatomic) BOOL loginStatus;
@end

