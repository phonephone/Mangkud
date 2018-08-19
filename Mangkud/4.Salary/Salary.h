//
//  Salary.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Salary : UIViewController <UITextFieldDelegate>
{
    AppDelegate *delegate;
    
    NSLocale *locale;
    NSDateFormatter *df;
    UIDatePicker *datePicker;
    NSMutableDictionary *payrollJSON;
    
    NSDate *showDate;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (weak, nonatomic) IBOutlet UILabel *topLabel1;
@property (weak, nonatomic) IBOutlet UILabel *topLabel2;
@property (weak, nonatomic) IBOutlet UILabel *topLabel3;
@property (weak, nonatomic) IBOutlet UILabel *topLabel4;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabelL1;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabelL2;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabelL3;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabelL4;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabelR1;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabelR2;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabelR3;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabelR4;
@end
