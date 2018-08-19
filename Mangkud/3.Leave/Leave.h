//
//  Leave.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Leave : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *delegate;
    NSMutableDictionary *leaveTopicJSON;
    NSMutableDictionary *leaveJSON;
}
@property (nonatomic) NSString *mode;

@property (retain, nonatomic) IBOutlet UITableView *myTable;
@property (retain, nonatomic) IBOutlet UIButton *leaveBtn;
@property (retain, nonatomic) IBOutlet UIButton *otBtn;

- (void)loadList;
@end
