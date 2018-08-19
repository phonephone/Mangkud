//
//  LeaveForm.m
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "LeaveForm.h"
#import "Leave.h"

@interface LeaveForm ()
{
    
}
@end

@implementation LeaveForm

@synthesize mode,action,leaveTopicArray,leaveDetailArray,otHourArray,titleLabel,startLabel,endLabel,typeLabel,detailLabel,startField,endField,typeField,detailText,sendBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"mode %@",mode);
    NSLog(@"leaveTopicArray %@",leaveTopicArray);
    NSLog(@"leaveDetailArray %@",leaveDetailArray);
    
    otHourArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    
    titleLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize+8];
    
    startLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    endLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    typeLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    detailLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    startField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    endField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    typeField.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    detailText.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+2];
    
    [self addbottomBorder:startField withColor:nil];
    [self addbottomBorder:endField withColor:nil];
    [self addbottomBorder:typeField withColor:nil];
    
    detailText.delegate = self;
    detailText.layer.borderWidth = 1.0f;
    detailText.layer.borderColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    [detailText  setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    sendBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:locale];
    
    hf = [[NSDateFormatter alloc] init];
    [hf setLocale:locale];
    
    if ([mode isEqualToString:@"Leave"]) {
        titleLabel.text = @"เพิ่มการลา";
        startLabel.text = @"วันที่เริ่มต้น";
        endLabel.text = @"วันที่สิ้นสุด";
        typeLabel.text = @"ประเภทการลา";
        
        startPicker = [[UIDatePicker alloc]init];
        [startPicker setDatePickerMode:UIDatePickerModeDate];
        [startPicker setMinimumDate: [NSDate date]];
        [startPicker setLocale:locale];
        startPicker.calendar = [locale objectForKey:NSLocaleCalendar];
        startPicker.tag = 1;
        [startPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        startField.inputView = startPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        startField.text = [df stringFromDate:[NSDate date]];
        
        endPicker = [[UIDatePicker alloc]init];
        [endPicker setDatePickerMode:UIDatePickerModeDate];
        [endPicker setMinimumDate: [NSDate date]];
        [endPicker setLocale:locale];
        endPicker.calendar = [locale objectForKey:NSLocaleCalendar];
        endPicker.tag = 2;
        [endPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        endField.inputView = endPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        endField.text = [df stringFromDate:[NSDate date]];
        
        typePicker = [[UIPickerView alloc]init];
        typePicker.delegate = self;
        typePicker.dataSource = self;
        [typePicker setShowsSelectionIndicator:YES];
        typePicker.tag = 3;
        [typePicker selectRow:0 inComponent:0 animated:YES];
        
        typeField.inputView = typePicker;
        typeField.text = [[leaveTopicArray objectAtIndex:0] objectForKey:@"leave_detail"];
        leavetypeID = [[leaveTopicArray objectAtIndex:0] objectForKey:@"leave_detail_id"];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        titleLabel.text = @"เพิ่มการขอ OT";
        startLabel.text = @"วันที่";
        endLabel.text = @"เวลาเริ่มต้น";
        typeLabel.text = @"จำนวนชั่วโมง";
        
        startPicker = [[UIDatePicker alloc]init];
        [startPicker setDatePickerMode:UIDatePickerModeDate];
        [startPicker setMaximumDate: [NSDate date]];
        [startPicker setLocale:locale];
        startPicker.calendar = [locale objectForKey:NSLocaleCalendar];
        startPicker.tag = 1;
        [startPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        startField.inputView = startPicker;
        [df setDateFormat:@"dd MMM yyyy"];
        startField.text = [df stringFromDate:[NSDate date]];
        
        endPicker = [[UIDatePicker alloc]init];
        [endPicker setDatePickerMode:UIDatePickerModeTime];
        [endPicker setLocale:locale];
        endPicker.calendar = [locale objectForKey:NSLocaleCalendar];
        endPicker.tag = 2;
        [endPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
        
        endField.inputView = endPicker;
        [hf setDateFormat:@"HH:mm"];
        endField.text = [hf stringFromDate:[NSDate date]];
        
        typePicker = [[UIPickerView alloc]init];
        typePicker.delegate = self;
        typePicker.dataSource = self;
        [typePicker setShowsSelectionIndicator:YES];
        typePicker.tag = 3;
        [typePicker selectRow:0 inComponent:0 animated:YES];
        
        typeField.inputView = typePicker;
        typeField.text = @"1";
        hourNumber = typeField.text;
    }
    
    if([action isEqualToString:@"edit"])
    {
        [self editInitial];
    }
}

- (void)editInitial
{
    if ([mode isEqualToString:@"Leave"]) {
        titleLabel.text = @"แก้ไขการลา";
        NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        [df2 setLocale:locale2];
        [df2 setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"start_date"]];
        NSDate *endDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"end_date"]];
        startField.text = [df stringFromDate:startDate];
        endField.text = [df stringFromDate:endDate];
        [startPicker setDate:startDate];
        [endPicker setDate:endDate];;
        
        for (int i=0; i<3; i++)
        {
            NSMutableDictionary *topicArray = [leaveTopicArray objectAtIndex:i];
            if ([[leaveDetailArray objectForKey:@"leave_detail_id"] isEqualToString:[topicArray objectForKey:@"leave_detail_id"]]) {
                typeField.text = [topicArray objectForKey:@"leave_detail"];
                leavetypeID = [leaveDetailArray objectForKey:@"leave_detail_id"];
                [typePicker selectRow:i inComponent:0 animated:YES];
            }
            else{
                
            }
        }
    }
    else if ([mode isEqualToString:@"OT"])
    {
        titleLabel.text = @"แก้ไขการขอ OT";
        NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
        [df2 setLocale:locale2];
        [df2 setDateFormat:@"dd/MM/yyyy"];//[df2 setDateFormat:@"yyyy-MM-dd"];//****************************************************
        NSDate *startDate = [df2 dateFromString:[leaveDetailArray objectForKey:@"date"]];
        startField.text = [df stringFromDate:startDate];
        [startPicker setDate:startDate];
        
        NSDate *endDate = [hf dateFromString:[leaveDetailArray objectForKey:@"start_time"]];
        endField.text = [hf stringFromDate:endDate];
        [endPicker setDate:endDate];
        
        typeField.text = [leaveDetailArray objectForKey:@"time_limit"];
        for (int i=0; i<[otHourArray count]; i++)
        {
            if ([typeField.text isEqualToString:[otHourArray objectAtIndex:i]]) {
                [typePicker selectRow:i inComponent:0 animated:YES];
            }
            else{
                
            }
        }
    }
    
    detailText.text = [leaveDetailArray objectForKey:@"reason"];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Start Date
            [df setDateFormat:@"dd MMM yyyy"];
            startField.text = [df stringFromDate:startPicker.date];
            if ([mode isEqualToString:@"Leave"])
            {
                [endPicker setMinimumDate:startPicker.date];
                endField.text = [df stringFromDate:startPicker.date];
                //[df setDateFormat:@"yyyy-MM-dd"];
                //goDate = [df stringFromDate:datePicker.date];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                
            }
            break;
            
        case 2://End Date
            if ([mode isEqualToString:@"Leave"])
            {
                endField.text = [df stringFromDate:endPicker.date];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                endField.text = [hf stringFromDate:endPicker.date];
            }
            break;
    }
}

- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    long rowNum = 0;
    
    switch (pickerView.tag)
    {
        case 3://Type , HOUR
            if ([mode isEqualToString:@"Leave"])
            {
                rowNum = [leaveTopicArray count];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                rowNum = [otHourArray count];
            }
            
            break;
            
        default:
            break;
    }
    return rowNum;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTitle;
    
    switch (pickerView.tag)
    {
        case 3://Type
            if ([mode isEqualToString:@"Leave"])
            {
                rowTitle = [[leaveTopicArray objectAtIndex:row] objectForKey:@"leave_detail"];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                rowTitle = [otHourArray objectAtIndex:row];
            }
            break;
            
        default:
            break;
    }
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 3://Type
            
            if ([mode isEqualToString:@"Leave"])
            {
                typeField.text = [[leaveTopicArray objectAtIndex:row] objectForKey:@"leave_detail"];
                leavetypeID = [[leaveTopicArray objectAtIndex:row] objectForKey:@"leave_detail_id"];
            }
            else if ([mode isEqualToString:@"OT"])
            {
                typeField.text = [otHourArray objectAtIndex:row];
                hourNumber = typeField.text;
            }
            break;
            
        default:
            break;
    }
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f+(textField.frame.size.width)*0.05,textField.frame.size.height+8, textField.frame.size.width, 1.0f);
    
    if (color == nil) {
        bottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1].CGColor;
    }
    else{
        bottomBorder.backgroundColor = color.CGColor;
        //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, userField.frame.size.width, 20)];
        //textField.rightView = paddingView;
        //textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [textField.layer addSublayer:bottomBorder];
    
    return textField;
}

- (IBAction)sendClicked:(id)sender
{
    NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setLocale:locale2];
    [df2 setDateFormat:@"dd-MM-yyyy"];
    NSString *startDate = [df2 stringFromDate:startPicker.date];
    NSString *endDate;
    if ([mode isEqualToString:@"Leave"])
    {
        endDate = [df2 stringFromDate:endPicker.date];
    }
    else if ([mode isEqualToString:@"OT"])
    {
        endDate = [hf stringFromDate:endPicker.date];
    }
    
    NSString* url;
    NSString *encodeReason = [detailText.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    if([action isEqualToString:@"add"])
    {
        if ([mode isEqualToString:@"Leave"])
        {
            //http://mangkud.co/index.php?MobileApi/createLeaveData/3/20-04-2018/25-04-2018/1/ลาไปเที่ยว
            url = [NSString stringWithFormat:@"%@createLeaveData/%@/%@/%@/%@/%@",HOST_DOMAIN,delegate.userID,startDate,endDate,leavetypeID,encodeReason];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            url = [NSString stringWithFormat:@"%@createOvertimeData/%@/%@/%@/%@/%@",HOST_DOMAIN,delegate.userID,startDate,endDate,hourNumber,encodeReason];
        }
    }
    else if([action isEqualToString:@"edit"])
    {
        if ([mode isEqualToString:@"Leave"])
        {
            //http://mangkud.co/index.php?MobileApi/updateLeaveData/2/01-03-2018/03-01-2018/1/ลาไปนอนเล่นชายหาด
            url = [NSString stringWithFormat:@"%@updateLeaveData/%@/%@/%@/%@/%@",HOST_DOMAIN,[leaveDetailArray objectForKey:@"leave_id"],startDate,endDate,leavetypeID,encodeReason];
        }
        else if ([mode isEqualToString:@"OT"])
        {
            //http://mangkud.co/index.php?MobileApi/updateLeaveData/2/01-03-2018/03-01-2018/1/ลาไปนอนเล่นชายหาด
            url = [NSString stringWithFormat:@"%@updateOvertimeData/%@/%@/%@/%@/%@",HOST_DOMAIN,[leaveDetailArray objectForKey:@"ot_id"],startDate,endDate,hourNumber,encodeReason];
        }
        
    }
    NSLog(@"URL %@",url);
    [SVProgressHUD showWithStatus:@"Loading"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             
             Leave* viewController = (Leave*)[self.parentViewController.childViewControllers objectAtIndex:0];
             [viewController loadList];
             [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
