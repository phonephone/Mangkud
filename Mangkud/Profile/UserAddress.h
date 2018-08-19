//
//  UserAddress.h
//  Mangkud
//
//  Created by Firststep Consulting on 14/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserAddress : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel1;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel2;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel3;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel4;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel5;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel6;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel7;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel8;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel9;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel10;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel11;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel12;

@property (weak, nonatomic) IBOutlet UITextField *addressField1;
@property (weak, nonatomic) IBOutlet UITextField *addressField2;
@property (weak, nonatomic) IBOutlet UITextField *addressField3;
@property (weak, nonatomic) IBOutlet UITextField *addressField4;
@property (weak, nonatomic) IBOutlet UITextField *addressField5;
@property (weak, nonatomic) IBOutlet UITextField *addressField6;
@property (weak, nonatomic) IBOutlet UITextField *addressField7;
@property (weak, nonatomic) IBOutlet UITextField *addressField8;
@property (weak, nonatomic) IBOutlet UITextField *addressField9;
@property (weak, nonatomic) IBOutlet UITextField *addressField10;
@property (weak, nonatomic) IBOutlet UITextField *addressField11;
@property (weak, nonatomic) IBOutlet UITextField *addressField12;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end
