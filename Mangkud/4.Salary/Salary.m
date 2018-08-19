//
//  Salary.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "Salary.h"
#import "AdminChat.h"
#import "AdminChatWeb.h"

@interface Salary ()

@end

@implementation Salary

@synthesize titleLabel,dateLabel,dateField,dateBtn,topLabel1,topLabel2,topLabel3,topLabel4,bottomLabelL1,bottomLabelL2,bottomLabelL3,bottomLabelL4,bottomLabelR1,bottomLabelR2,bottomLabelR3,bottomLabelR4;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    dateLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    
    dateField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1];
    
    
    float fontSizeTop = delegate.fontSize-1;
    topLabel1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeTop];
    topLabel2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeTop];
    topLabel3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeTop];
    topLabel4.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeTop];
    
    float fontSizeBottom = delegate.fontSize+1;
    bottomLabelL1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    bottomLabelL2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    bottomLabelL3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    bottomLabelL4.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    
    bottomLabelR1.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    bottomLabelR2.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    bottomLabelR3.font = [UIFont fontWithName:delegate.fontRegular size:fontSizeBottom];
    bottomLabelR4.font = [UIFont fontWithName:delegate.fontBold size:fontSizeBottom];
    
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1]; // note that I'm setting it to -1
    NSDate *beforeAMonth = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:locale];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMaximumDate: [NSDate date]];
    [datePicker setDate:beforeAMonth];
    [datePicker setLocale:locale];
    datePicker.calendar = [locale objectForKey:NSLocaleCalendar];
    datePicker.tag = 1;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    dateField.inputView = datePicker;
    [df setDateFormat:@"MMMM yyyy"];
    dateField.text = [df stringFromDate:beforeAMonth];
    
    [self loadPayrollforDate:beforeAMonth];
}

- (void)loadPayrollforDate:(NSDate*)date
{
    showDate = date;
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:locale2];
    [df2 setDateFormat:@"yyyy-MM"];
    NSString *payrollDate = [df2 stringFromDate:date];
    NSString* url = [NSString stringWithFormat:@"%@payroll_detail/%@/%@",HOST_DOMAIN,delegate.userID,payrollDate];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"PayrollJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             payrollJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             
             //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismiss];
             [self updatePayroll];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismissWithDelay:1.5];
             [self clearPayroll];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

- (void)clearPayroll
{
    topLabel1.text = @"Payroll Code : ";
    topLabel2.text = @"พนักงาน : ";
    topLabel3.text = @"วันที่ : ";
    topLabel4.text = @"สถานะ : ";
    
    bottomLabelR1.text = @"฿";
    bottomLabelR2.text = @"฿";
    bottomLabelR3.text = @"฿";
    bottomLabelR4.text = @"฿";
}

- (void)updatePayroll
{
    topLabel1.text = [NSString stringWithFormat:@"Payroll Code : %@",[payrollJSON objectForKey:@"payroll_code"]];
    topLabel2.text = [NSString stringWithFormat:@"พนักงาน : %@",delegate.userFullname];
    [df setDateFormat:@"MMMM, yyyy"];
    topLabel3.text = [NSString stringWithFormat:@"วันที่ : %@",[df stringFromDate:showDate]];
    topLabel4.text = [NSString stringWithFormat:@"สถานะ : %@",[payrollJSON objectForKey:@"payroll_status"]];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    bottomLabelR1.text = [NSString stringWithFormat:@"฿ %@",[formatter stringFromNumber:[NSNumber numberWithInteger:[[payrollJSON objectForKey:@"joining_salary"]integerValue]]]];
    bottomLabelR2.text = [NSString stringWithFormat:@"฿ %@",[formatter stringFromNumber:[NSNumber numberWithInteger:[[payrollJSON objectForKey:@"total_allowance"]integerValue]]]];
    bottomLabelR3.text = [NSString stringWithFormat:@"฿ %@",[formatter stringFromNumber:[NSNumber numberWithInteger:[[payrollJSON objectForKey:@"total_deduction"]integerValue]]]];
    bottomLabelR4.text = [NSString stringWithFormat:@"฿ %@",[formatter stringFromNumber:[NSNumber numberWithInteger:[[payrollJSON objectForKey:@"net_salary"]integerValue]]]];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Start Date
            [df setDateFormat:@"MMMM yyyy"];
            dateField.text = [df stringFromDate:datePicker.date];
            [self loadPayrollforDate:datePicker.date];
            
            //[df setDateFormat:@"yyyy-MM-dd"];
            //goDate = [df stringFromDate:datePicker.date];
            break;
    }
}

- (IBAction)dateClicked:(id)sender
{
    [dateField becomeFirstResponder];
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
