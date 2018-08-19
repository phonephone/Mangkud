//
//  Leave.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Leave.h"
#import "LeaveCell.h"
#import "LeaveForm.h"
#import "AdminChat.h"
#import "FTPopOverMenu.h"
#import "AdminChatWeb.h"

@interface Leave ()

@end

@implementation Leave

@synthesize mode,myTable,leaveBtn,otBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    leaveBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    otBtn.titleLabel.font = [UIFont fontWithName:delegate.fontSemibold size:delegate.fontSize-1];
    
    mode = @"Leave";
    [self loadTopic];
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
}

- (IBAction)leaveClick:(id)sender
{
    mode = @"Leave";
    [leaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leaveBtn setBackgroundColor:[UIColor colorWithRed:115.0/255 green:188.0/255 blue:66.0/255 alpha:1]];
    [otBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [otBtn setBackgroundColor:[UIColor whiteColor]];
    [self loadList];
}

- (IBAction)otClick:(id)sender
{
    mode = @"OT";
    [otBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otBtn setBackgroundColor:[UIColor colorWithRed:115.0/255 green:188.0/255 blue:66.0/255 alpha:1]];
    [leaveBtn setTitleColor:[UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:1] forState:UIControlStateNormal];
    [leaveBtn setBackgroundColor:[UIColor whiteColor]];
    [self loadList];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadTopic];
}

- (void)loadTopic
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@getLeaveTopicList/%@",HOST_DOMAIN,delegate.adminID];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"LeaveJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             leaveTopicJSON = responseObject;
             [self loadList];
         }
         else{
             [self loadTopic];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self loadTopic];
     }];
}

- (void)loadList
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url;
    if ([mode isEqualToString:@"Leave"]) {
        url = [NSString stringWithFormat:@"%@getLeaveList/%@",HOST_DOMAIN,delegate.userID];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@getOverTimeList/%@",HOST_DOMAIN,delegate.userID];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"LeaveJSON %@",responseObject);
         leaveJSON = responseObject;
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismiss];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
         [myTable reloadData];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.height/14;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LeaveCell *headerCell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
    
    NSString *fontName = delegate.fontSemibold;
    float fontSizeHeader = delegate.fontSize-1;
    headerCell.Label1.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label2.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label3.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label4.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    headerCell.Label5.font = [UIFont fontWithName:fontName size:fontSizeHeader];
    
    if ([mode isEqualToString:@"Leave"]) {
        headerCell.Label1.text = @"วันที่เริ่มต้น";
        headerCell.Label2.text = @"วันที่สิ้นสุด";
        headerCell.Label3.text = @"ประเภท";
        headerCell.Label4.text = @"สถานะ";
        headerCell.Label5.text = @"ทางเลือก";
    }
    else if ([mode isEqualToString:@"OT"])
    {
        headerCell.Label1.text = @"วันที่";
        headerCell.Label2.text = @"เวลา";
        headerCell.Label3.text = @"จำนวน(ชม.)";
        headerCell.Label4.text = @"สถานะ";
        headerCell.Label5.text = @"ทางเลือก";
    }
    
    int sectionHeight = (self.view.frame.size.height/14);
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0,sectionHeight-1,self.view.frame.size.width,1)];
    separator.backgroundColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:234.0/255 alpha:1];
    [headerCell addSubview:separator];
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[leaveJSON objectForKey:@"status"] isEqualToString:@"success"]) {
        return [[leaveJSON objectForKey:@"data"] count];
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowHeight;
    
    rowHeight = (self.view.frame.size.height/15);
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaveCell *cell = (LeaveCell *)[tableView dequeueReusableCellWithIdentifier:@"LeaveCell"];
    
    NSDictionary *cellArray = [[leaveJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    float fontSizeCell = delegate.fontSize-3;
    cell.Label1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    cell.Label4.font = [UIFont fontWithName:delegate.fontBold size:fontSizeCell];
    cell.actionBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeCell];
    
    if(indexPath.row % 2)
    {
        cell.contentView.backgroundColor= [UIColor colorWithRed:250.0/255 green:224.0/255 blue:237.0/255 alpha:1];
    }
    else
    {
        cell.contentView.backgroundColor= [UIColor whiteColor];
    }
    
    if ([mode isEqualToString:@"Leave"]) {
        cell.Label1.text = [cellArray objectForKey:@"start_date"];
        cell.Label2.text = [cellArray objectForKey:@"end_date"];
        for (int i=0; i<3; i++)
        {
            NSMutableDictionary *topicArray = [[leaveTopicJSON objectForKey:@"data"] objectAtIndex:i];
            if ([[cellArray objectForKey:@"leave_detail_id"] isEqualToString:[topicArray objectForKey:@"leave_detail_id"]]) {
                cell.Label3.text = [topicArray objectForKey:@"leave_detail"];
            }
            else{
                
            }
        }
    }
    else if ([mode isEqualToString:@"OT"])
    {
        cell.Label1.text = [cellArray objectForKey:@"date"];
        cell.Label2.text = [cellArray objectForKey:@"start_time"];
        cell.Label3.text = [cellArray objectForKey:@"time_limit"];
    }
    
    if([[cellArray objectForKey:@"status"] isEqualToString:@"1"])
    {
        cell.Label4.text = @"อนุมัติ";
        cell.Label4.textColor = [UIColor colorWithRed:49.0/255 green:107.0/255 blue:4.0/255 alpha:1];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else if([[cellArray objectForKey:@"status"] isEqualToString:@"2"])
    {
        cell.Label4.text = @"ไม่อนุมัติ";
        cell.Label4.textColor = [UIColor colorWithRed:194.0/255 green:56.0/255 blue:37.0/255 alpha:1];
        cell.actionBtn.hidden = YES;
        cell.dropdownBtn.hidden = YES;
    }
    else
    {
        cell.Label4.text = @"รออนุมัติ";
        cell.Label4.textColor = [UIColor colorWithRed:37.0/255 green:124.0/255 blue:191.0/255 alpha:1];
        cell.actionBtn.hidden = NO;
        cell.dropdownBtn.hidden = NO;
    }
    
    [cell.actionBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.actionBtn.tag = indexPath.row;
    
    [cell.dropdownBtn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.dropdownBtn.tag = indexPath.row;
    
    /*
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];;
    [cell setSelectedBackgroundView:bgColorView];
    */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)actionClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    //NSLog(@"Action %ld",button.tag);
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = (self.view.frame.size.height/20);
    configuration.menuWidth = myTable.frame.size.width*0.2;
    configuration.textColor = [UIColor darkGrayColor];
    configuration.textFont = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-3];
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:234.0/255 alpha:1];
    configuration.borderWidth = 1;
    //configuration.textAlignment = ...
    //configuration.ignoreImageOriginalColor = ...;// set 'ignoreImageOriginalColor' to YES, images color will be same as textColor
    ///configuration.allowRoundedArrow = ...;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
    
    [FTPopOverMenu showForSender:sender withMenuArray:@[@" แก้ไข",@" ลบ"] doneBlock:^(NSInteger selectedIndex) {
        NSLog(@"Action %ld Menu %ld",button.tag,(long)selectedIndex);
        
        NSDictionary *cellArray = [[leaveJSON objectForKey:@"data"] objectAtIndex:button.tag];
        
        if (selectedIndex == 0) {
            //NSLog(@"Edit %@",[cellArray objectForKey:@"leave_id"]);
            [self editClicked:cellArray];
        }
        else if (selectedIndex == 1) {
            //NSLog(@"Delete %@",[cellArray objectForKey:@"leave_id"]);
            
            if ([mode isEqualToString:@"Leave"]) {
                [self deleteClicked:[cellArray objectForKey:@"leave_id"]];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                [self deleteClicked:[cellArray objectForKey:@"ot_id"]];
            }
        }
    } dismissBlock:^{
        NSLog(@"Close");
    }];
}

- (void)deleteClicked:(NSString*)leaveID
{
    [SVProgressHUD showWithStatus:@"Canceling Request"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url;
    if ([mode isEqualToString:@"Leave"]) {
        url = [NSString stringWithFormat:@"%@deleteLeaveData/%@",HOST_DOMAIN,leaveID];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        url = [NSString stringWithFormat:@"%@deleteOvertimeData/%@",HOST_DOMAIN,leaveID];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"DeleteJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             [self loadList];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (void)editClicked:(NSDictionary*)leaveDetail
{
    LeaveForm *viewController = [[LeaveForm alloc]initWithNibName:@"LeaveForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"edit";
    viewController.leaveTopicArray = [leaveTopicJSON objectForKey:@"data"];
    viewController.leaveDetailArray = leaveDetail;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)addClicked:(id)sender
{
    LeaveForm *viewController = [[LeaveForm alloc]initWithNibName:@"LeaveForm" bundle:nil];
    viewController.mode = mode;
    viewController.action = @"add";
    viewController.leaveTopicArray = [leaveTopicJSON objectForKey:@"data"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)rightMenu:(id)sender {
    AdminChatWeb *viewController = [[AdminChatWeb alloc]initWithNibName:@"AdminChatWeb" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
