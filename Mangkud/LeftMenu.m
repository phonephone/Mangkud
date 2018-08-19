//
//  LeftMenu.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "LeftMenu.h"
#import "MenuCell.h"
#import "Login.h"
#import "UIImageView+WebCache.h"
#import "Tabbar.h"
#import "UserReport.h"
#import "UserProfile.h"
#import "UserAddress.h"
#import "UserBank.h"
#import "UserDocument.h"
#import "ResetPassword.h"

@interface LeftMenu ()

@end

@implementation LeftMenu

@synthesize companyPic,userName,myTable;

- (void)viewWillLayoutSubviews
{
    [myTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    userName.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    [self updateProfile];
}

- (void)viewDidLayoutSubviews
{
    //Circle
    companyPic.layer.cornerRadius = companyPic.frame.size.width/2;
    companyPic.layer.masksToBounds = YES;
    
    //Border
    //profilePic.layer.borderWidth = 3.0f;
    //profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [myTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
     Navi *navi = (Navi*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:2];
     homePage = (Home*)[navi.childViewControllers objectAtIndex:0];
     
     carbon = [homePage.childViewControllers objectAtIndex:0];
     */
    
    //NSLog(@"count %@",[carbon.viewControllers objectForKey:[NSNumber numberWithInt:0]]);
}

- (void)updateProfile
{
    [companyPic sd_setImageWithURL:[NSURL URLWithString:delegate.userLogoUrl] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    userName.text = delegate.userFullname;
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    //AAif (section == 99) return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            if (section == 99) {
                return 3+1;
            }
        }
        return 1; // only top row showing
    }
    // Return the number of rows in other section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    int rowHeight;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (!indexPath.row)//Main
        {
            rowHeight = (self.view.frame.size.height/18);
        }
        else//Sub
        {
            rowHeight = (self.view.frame.size.height/18);
        }
    }
    else//Can't Expand
    {
        rowHeight = (self.view.frame.size.height/18);
    }
    */
    return self.view.frame.size.height/18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
    //[cell setSelectedBackgroundView:bgColorView];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])//Expandable
    {
        if (indexPath.section == 99)
        {
            //cell.backgroundColor = [UIColor colorWithRed:206.0/255 green:206.0/255 blue:206.0/255 alpha:1];
            
            if (indexPath.row == 0) {
                cell.menuLabel.text = @"แก้ไขข้อมูลส่วนบุคคล";
                bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
                [cell setSelectedBackgroundView:bgColorView];
            }
            else if (indexPath.row == 1) {
                cell.menuLabel.text = @"    รายละเอียดส่วนบุคคล";
            }
            else if (indexPath.row == 2) {
                cell.menuLabel.text = @"    รายละเอียดที่อยู่";
            }
            else if (indexPath.row == 3) {
                cell.menuLabel.text = @"    รายละเอียดบัญชีธนาคาร";
            }
        }
        
        cell.menuLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize];
        cell.menuArrow.hidden = NO;
        
        if (!indexPath.row)//Main
        {
            if ([expandedSections containsIndex:indexPath.section])//Now Expanded
            {
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else//Not Expanded
            {
                //float degrees = 180; //the value in degrees
                //cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
        }
        else//Sub
        {
            cell.menuLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize];
            cell.menuArrow.hidden = YES;
        }
    }
    else//Can't Expand
    {
        if (indexPath.section == 0) {
            cell.menuLabel.text = @"รายละเอียดส่วนบุคคล";
        }
        else if (indexPath.section == 1) {
            cell.menuLabel.text = @"เปลี่ยนรหัสผ่าน";
        }
        else if (indexPath.section == 2) {
            cell.menuLabel.text = @"ออกจากระบบ";
        }
        
        cell.menuLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize];
        cell.menuArrow.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tabbar *tab = (Tabbar*)[[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers objectAtIndex:1];
    UINavigationController *navi = tab.selectedViewController;// [tab.childViewControllers objectAtIndex:1];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)//Main Menu Click
        {
            // only first row toggles exapand/collapse
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformIdentity;
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
                
                float degrees = 90; //the value in degrees
                MenuCell *cell = [myTable cellForRowAtIndexPath:indexPath];
                cell.menuArrow.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
            }
            
            //Table row management
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                [myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:section]-1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        else//Sub Menu Click
        {
            if (indexPath.section == 99)
            {
                if (indexPath.row == 1) {//รายละเอียดส่วนบุคคล
                    viewController = [[UserProfile alloc]initWithNibName:@"UserProfile" bundle:nil];
                }
                else if (indexPath.row == 2) {//รายละเอียดที่อยู่
                    viewController = [[UserAddress alloc]initWithNibName:@"UserAddress" bundle:nil];
                }
                else if (indexPath.row == 3) {//รายละเอียดบัญชีธนาคาร
                    viewController = [[UserBank alloc]initWithNibName:@"UserBank" bundle:nil];
                }
            }
            [navi pushViewController:viewController animated:YES];
            
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
        }
    }
    
    else // can't collapse
    {
        if (indexPath.section == 0){//AAif (indexPath.section == 0) {//รายงานการเข้างาน
            viewController = [[UserProfile alloc]initWithNibName:@"UserProfile" bundle:nil];
            [navi pushViewController:viewController animated:YES];
        }
        else if (indexPath.section == 1) {//เปลี่ยนรหัสผ่าน
            viewController = [[ResetPassword alloc]initWithNibName:@"ResetPassword" bundle:nil];
            [navi pushViewController:viewController animated:YES];
        }
        else if (indexPath.section == 2){//ออกจากระบบ
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            delegate.loginStatus = NO;
            delegate.userID = @"";
            delegate.adminID = @"";
            delegate.userLogoUrl = @"";
            delegate.userFullname = @"";
            
            [ud setBool:delegate.loginStatus forKey:@"loginStatus"];
            [ud setObject:delegate.userID forKey:@"userID"];
            [ud setObject:delegate.adminID forKey:@"adminID"];
            [ud setObject:delegate.userLogoUrl forKey:@"userLogoUrl"];
            [ud setObject:delegate.userFullname forKey:@"userFullname"];
            [ud synchronize];
            
            Login *log = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.menuContainerViewController setCenterViewController:log];
        }
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
    }
}

- (void)clearToken
{
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = [NSString stringWithFormat:@"%@logout",HOST_DOMAIN];
    NSDictionary *parameters = @{@"userEmail":delegate.memberEmail
                                 };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"logoutJSON %@",responseObject);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
     }];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
