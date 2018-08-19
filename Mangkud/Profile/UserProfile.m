//
//  UserProfile.m
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "UserProfile.h"
#import "UIImageView+WebCache.h"

@interface UserProfile ()
{
    NSArray *genderArray;
    NSArray *marryArray;
}
@end

@implementation UserProfile

@synthesize titleLabel,firstnameLabel,lastnameLabel,idLabel,birthdayLabel,genderLabel,telLabel,nationalityLabel,addressLabel,marryLabel,picLabel,firstnameField,lastnameField,idField,birthdayField,genderField,telField,nationalityField,addressField,marryField,profilePic,cameraBtn,submitBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    genderArray = @[@"ชาย",@"หญิง"];
    marryArray = @[@"โสด",@"สมรส",@"หย่าร้าง"];//074271666 ขวัญนภา
    
    titleLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize+6];
    
    NSString *fontName = delegate.fontLight;
    float fontSize = delegate.fontSize+1;
    firstnameLabel.font = [UIFont fontWithName:fontName size:fontSize];
    lastnameLabel.font = [UIFont fontWithName:fontName size:fontSize];
    idLabel.font = [UIFont fontWithName:fontName size:fontSize];
    birthdayLabel.font = [UIFont fontWithName:fontName size:fontSize];
    genderLabel.font = [UIFont fontWithName:fontName size:fontSize];
    telLabel.font = [UIFont fontWithName:fontName size:fontSize];
    nationalityLabel.font = [UIFont fontWithName:fontName size:fontSize];
    marryLabel.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel.font = [UIFont fontWithName:fontName size:fontSize];
    picLabel.font = [UIFont fontWithName:fontName size:fontSize];
    
    firstnameField.font = [UIFont fontWithName:fontName size:fontSize];
    lastnameField.font = [UIFont fontWithName:fontName size:fontSize];
    idField.font = [UIFont fontWithName:fontName size:fontSize];
    birthdayField.font = [UIFont fontWithName:fontName size:fontSize];
    genderField.font = [UIFont fontWithName:fontName size:fontSize];
    telField.font = [UIFont fontWithName:fontName size:fontSize];
    nationalityField.font = [UIFont fontWithName:fontName size:fontSize];
    marryField.font = [UIFont fontWithName:fontName size:fontSize];
    addressField.font = [UIFont fontWithName:fontName size:fontSize];
    
    firstnameField.userInteractionEnabled = NO;
    lastnameField.userInteractionEnabled = NO;
    idField.userInteractionEnabled = NO;
    birthdayField.userInteractionEnabled = NO;
    genderField.userInteractionEnabled = NO;
    telField.userInteractionEnabled = NO;
    nationalityField.userInteractionEnabled = NO;
    marryField.userInteractionEnabled = NO;
    addressField.userInteractionEnabled = NO;
    
    submitBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    
    [self addbottomBorder:firstnameField withColor:nil];
    [self addbottomBorder:lastnameField withColor:nil];
    [self addbottomBorder:idField withColor:nil];
    [self addbottomBorder:birthdayField withColor:nil];
    [self addbottomBorder:genderField withColor:nil];
    [self addbottomBorder:telField withColor:nil];
    [self addbottomBorder:nationalityField withColor:nil];
    [self addbottomBorder:marryField withColor:nil];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterShortStyle;
    [df setLocale:locale];
    
    birthdayPicker = [[UIDatePicker alloc]init];
    [birthdayPicker setDatePickerMode:UIDatePickerModeDate];
    [birthdayPicker setMaximumDate: [NSDate date]];
    [birthdayPicker setLocale:locale];
    birthdayPicker.calendar = [locale objectForKey:NSLocaleCalendar];
    birthdayPicker.tag = 1;
    [birthdayPicker addTarget:self action:@selector(datePickerValueChanged:)forControlEvents:UIControlEventValueChanged];
    
    birthdayField.inputView = birthdayPicker;
    [df setDateFormat:@"EEEE, dd MMM yyyy"];
    birthdayField.text = [df stringFromDate:[NSDate date]];
    
    genderPicker = [[UIPickerView alloc]init];
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    [genderPicker setShowsSelectionIndicator:YES];
    genderPicker.tag = 2;
    [genderPicker selectRow:0 inComponent:0 animated:YES];
    
    genderField.inputView = genderPicker;
    genderField.text = [genderArray objectAtIndex:0];
    
    marryPicker = [[UIPickerView alloc]init];
    marryPicker.delegate = self;
    marryPicker.dataSource = self;
    [marryPicker setShowsSelectionIndicator:YES];
    marryPicker.tag = 3;
    [marryPicker selectRow:0 inComponent:0 animated:YES];
    
    marryField.inputView = marryPicker;
    marryField.text = [marryArray objectAtIndex:0];
    
    [self loadProfile];
}

- (void)viewDidLayoutSubviews
{
    //Border
    profilePic.layer.borderWidth = 1.5f;
    profilePic.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)loadProfile
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@empProfileDetail/%@",HOST_DOMAIN,delegate.userID];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ProfileJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             profileJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
             firstnameField.text = [profileJSON objectForKey:@"name"];
             lastnameField.text = [profileJSON objectForKey:@"lastname"];
             idField.text = [profileJSON objectForKey:@"green_card"];
             birthdayField.text = [profileJSON objectForKey:@"date_of_birth"];
             genderField.text = [profileJSON objectForKey:@"gender"];
             telField.text = [profileJSON objectForKey:@"phone"];
             nationalityField.text = [profileJSON objectForKey:@"nationality"];
             marryField.text = [profileJSON objectForKey:@"martial_status"];
             addressField.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[profileJSON objectForKey:@"local_address"],[profileJSON objectForKey:@"local_memberTumbon"],[profileJSON objectForKey:@"local_memberAmphor"],[profileJSON objectForKey:@"local_memberCity"],[profileJSON objectForKey:@"local_memberPostCode"]];
             [profilePic sd_setImageWithURL:[NSURL URLWithString:[profileJSON objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"logo_square.png"]];
             
             [SVProgressHUD dismiss];
             
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

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    switch (datePicker.tag) {
        case 1://Birthday
            [df setDateFormat:@"EEEE, dd MMM yyyy"];
            birthdayField.text = [df stringFromDate:birthdayPicker.date];
            
            //[df setDateFormat:@"yyyy-MM-dd"];
            //goDate = [df stringFromDate:datePicker.date];
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
        case 2://Gender
            rowNum = [genderArray count];
            break;
            
        case 3://Marry
            rowNum = [marryArray count];
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
        case 2://Gender
            rowTitle = [genderArray objectAtIndex:row];
            break;
            
        case 3://Marry
            rowTitle = [marryArray objectAtIndex:row];
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
        case 2://Gender
            genderField.text = [genderArray objectAtIndex:row];
            /*
             if (row == 1) {
             exTime = @"15";
             }
             else if (row == 2) {
             exTime = @"30";
             }
             else if (row == 3) {
             exTime = @"45";
             }
             else{
             exTime = [extimeArray objectAtIndex:row];
             }
             */
            break;
            
        case 3://Marry
            marryField.text = [marryArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height*0.95, textField.frame.size.width, 1.0f);
    
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
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (IBAction)cameraClick:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController  alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self selectImage:nil];
        
        //[self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
        [self takePhoto:nil];
        
        //[self dismissViewControllerAnimated:YES completion:^{ }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) selectImage:(UIButton *) sender {
    NSLog(@"selectImage");
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = self;
    [pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (void) takePhoto:(UIButton *) sender {
    NSLog(@"takePhoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerViewController =[[UIImagePickerController alloc]init];
        pickerViewController.allowsEditing = YES;
        pickerViewController.delegate = self;
        pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerViewController animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [profilePic setImage: image];
    [self dismissViewControllerAnimated:picker completion:nil];
}


- (IBAction)submitClick:(id)sender
{

}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
