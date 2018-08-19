//
//  LeaveForm.h
//  Mangkud
//
//  Created by Firststep Consulting on 28/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LeaveForm : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    AppDelegate *delegate;
    
    NSDateFormatter *df;
    NSDateFormatter *hf;
    UIDatePicker *startPicker;
    UIDatePicker *endPicker;
    UIPickerView *typePicker;
    
    NSString *leavetypeID;
    NSString *hourNumber;
}
@property (nonatomic) NSString *mode;
@property (nonatomic) NSString *action;
@property (nonatomic) NSMutableArray *leaveTopicArray;
@property (nonatomic) NSDictionary *leaveDetailArray;
@property (nonatomic) NSMutableArray *otHourArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *endField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextView *detailText;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end
