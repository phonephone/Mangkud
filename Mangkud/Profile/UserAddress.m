//
//  UserAddress.m
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "UserAddress.h"

@interface UserAddress ()

@end

@implementation UserAddress

@synthesize titleLabel,addressLabel1,addressLabel2,addressLabel3,addressLabel4,addressLabel5,addressLabel6,addressLabel7,addressLabel8,addressLabel9,addressLabel10,addressLabel11,addressLabel12,addressField1,addressField2,addressField3,addressField4,addressField5,addressField6,addressField7,addressField8,addressField9,addressField10,addressField11,addressField12,submitBtn;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize+6];
    
    NSString *fontName = delegate.fontLight;
    float fontSize = delegate.fontSize+1;
    addressLabel1.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel2.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel3.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel4.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel5.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel6.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel7.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel8.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel9.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel10.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel11.font = [UIFont fontWithName:fontName size:fontSize];
    addressLabel12.font = [UIFont fontWithName:fontName size:fontSize];
    
    addressField1.font = [UIFont fontWithName:fontName size:fontSize];
    addressField2.font = [UIFont fontWithName:fontName size:fontSize];
    addressField3.font = [UIFont fontWithName:fontName size:fontSize];
    addressField4.font = [UIFont fontWithName:fontName size:fontSize];
    addressField5.font = [UIFont fontWithName:fontName size:fontSize];
    addressField6.font = [UIFont fontWithName:fontName size:fontSize];
    addressField7.font = [UIFont fontWithName:fontName size:fontSize];
    addressField8.font = [UIFont fontWithName:fontName size:fontSize];
    addressField9.font = [UIFont fontWithName:fontName size:fontSize];
    addressField10.font = [UIFont fontWithName:fontName size:fontSize];
    addressField11.font = [UIFont fontWithName:fontName size:fontSize];
    addressField12.font = [UIFont fontWithName:fontName size:fontSize];
    
    submitBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+3];
    
    [self addbottomBorder:addressField1 withColor:nil];
    [self addbottomBorder:addressField2 withColor:nil];
    [self addbottomBorder:addressField3 withColor:nil];
    [self addbottomBorder:addressField4 withColor:nil];
    [self addbottomBorder:addressField5 withColor:nil];
    [self addbottomBorder:addressField6 withColor:nil];
    [self addbottomBorder:addressField7 withColor:nil];
    [self addbottomBorder:addressField8 withColor:nil];
    [self addbottomBorder:addressField9 withColor:nil];
    [self addbottomBorder:addressField10 withColor:nil];
    [self addbottomBorder:addressField11 withColor:nil];
    [self addbottomBorder:addressField12 withColor:nil];
}

- (UITextField*)addbottomBorder:(UITextField*)textField withColor:(UIColor*)color
{
    textField.delegate = self;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f,textField.frame.size.height*0.9, textField.frame.size.width, 1.0f);
    
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
